//
//  FeedView.swift
//  Gallery
//
//  Created by Анна Перехрест  on 2024/04/22.
//

import UIKit
import Combine

private typealias Module = Feed
private typealias View = Module.View

extension Module {
    class View: UIViewController {
        // MARK: - IBOutlets
        @IBOutlet private weak var activityView: UIActivityIndicatorView!
        @IBOutlet private weak var collectionView: UICollectionView!
        @IBOutlet private weak var searchBar: UISearchBar!

        // MARK: - Properties
        private var viewModel: Module.ViewModel = .init()


        // MARK: - View Lifecycle
        override func viewDidLoad() {
            super.viewDidLoad()
            
            collectionViewConfiguration()
        }

        deinit {
            NotificationCenter.default.removeObserver(self)
        }

        // MARK: - UI config
        func collectionViewConfiguration() {
            collectionView.dataSource = self
            collectionView.delegate = self

            let nib = UINib(nibName: "PhotoCollectionCell", bundle: nil)
                collectionView.register(nib, forCellWithReuseIdentifier: PhotoCollectionCell.reuseIdentifier)

            collectionLayoutConfiguration()

            bindViewModel()
            showActivityView()
            viewModel.fetchPhotos()
        }

        func collectionLayoutConfiguration() {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 8
            layout.minimumInteritemSpacing = 4
            collectionView.setCollectionViewLayout(layout, animated: true)

            NotificationCenter.default.addObserver(self, selector: #selector(orientationDidChange), name: UIDevice.orientationDidChangeNotification, object: nil)
        }

        @objc func orientationDidChange() {
            collectionView.reloadData()
        }

        // MARK: - ViewModel Binding
        func bindViewModel() {
            viewModel.$photos
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    self?.hideActivityView()
                    self?.collectionView.reloadData()
                }
                .store(in: &viewModel.cancellables)

            viewModel.$photoType
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    let topOffset = CGPoint(x: 0, y: -(self?.collectionView.contentInset.top ?? 0))
                    self?.collectionView.setContentOffset(topOffset, animated: true)
                }
                .store(in: &viewModel.cancellables)

            viewModel.$errorMessage
                .receive(on: DispatchQueue.main)
                .compactMap { $0 }
                .sink { [weak self] errorMessage in
                    self?.hideActivityView()
                    self?.showErrorAlert(message: errorMessage)
                }
                .store(in: &viewModel.cancellables)
        }

        // MARK: - Alert
        func showErrorAlert(message: String) {
            let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""),
                                          message: NSLocalizedString(message, comment: ""),
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""),
                                          style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }

        // MARK: - Activity Indicator
        func showActivityView() {
            activityView.isHidden = false
            activityView.startAnimating()
        }

        func hideActivityView() {
            activityView.isHidden = true
            activityView.stopAnimating()
        }
    }
}
// MARK: - UICollectionViewDataSource
extension View: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.photos.dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionCell.reuseIdentifier, for: indexPath) as? PhotoCollectionCell else {
            return UICollectionViewCell()
        }

        cell.configure(with: viewModel.photos.dataSource[indexPath.item])

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if let previewViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PreviewViewController") as? PreviewViewController {
            let photo = viewModel.photos.dataSource[indexPath.item]
            let preview = Preview.View(id: photo.id)
            navigationController?.pushViewController(preview, animated: true)
//        }
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == viewModel.photos.dataSource.count - 1 {
            viewModel.fetchNextPage()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension View: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 1.0, left: 8.0, bottom: 1.0, right: 8.0)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let lay = collectionViewLayout as! UICollectionViewFlowLayout
        let widthPerItem = collectionView.frame.width / 2 - lay.minimumInteritemSpacing

        return CGSize(width: widthPerItem - 8, height: 250)
    }
}

// MARK: - UISearchBarDelegate
extension View: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines), !query.isEmpty else {
            searchBarCancelButtonClicked(searchBar)
            return
        }

        searchBar.resignFirstResponder()

        prepareSearchPhotos(query: query)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.resignFirstResponder()

        resetSearchPhotos()
    }

    private func prepareSearchPhotos(query: String) {
        viewModel.photoType = .search
        viewModel.query = query
        viewModel.fetchPhotos()
    }

    private func resetSearchPhotos() {
        viewModel.photoType = .curated
        viewModel.query = nil
        viewModel.fetchPhotos()
    }
}
