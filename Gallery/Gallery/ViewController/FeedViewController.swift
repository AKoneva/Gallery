//
//  ViewController.swift
//  Gallery
//
//  Created by Анна Перехрест  on 2024/04/19.
//

import UIKit
import Combine

class FeedViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!

    private var viewModel = PhotoViewModel()
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionViewSetUp()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension FeedViewController {
    func collectionViewSetUp() {
        collectionView.dataSource = self
        collectionView.delegate = self

        collectionLayoutSetUp()
        bindViewModel()

        viewModel.fetchCuratedPhotos()
    }

    func collectionLayoutSetUp() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 4
        collectionView
            .setCollectionViewLayout(layout, animated: true)

        NotificationCenter.default.addObserver(self, selector: #selector(orientationDidChange), name: UIDevice.orientationDidChangeNotification, object: nil)
    }

    @objc func orientationDidChange() {
        collectionView.reloadData()
    }

    private func bindViewModel() {
        viewModel.$photos
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)

        viewModel.$photoType
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                let topOffset = CGPoint(x: 0, y: -(self?.collectionView.contentInset.top ?? 0))
                self?.collectionView.setContentOffset(topOffset, animated: true)
            }
            .store(in: &cancellables)
    }
}

extension FeedViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as? PhotoCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.configure(with: viewModel.photos[indexPath.item])

        return cell
    }

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

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let previewViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PreviewViewController") as? PreviewViewController {
            let photo = viewModel.photos[indexPath.item]
            previewViewController.photo = photo
            navigationController?.pushViewController(previewViewController, animated: true)
        }
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == viewModel.photos.count - 1 {
                viewModel.fetchNextPage()
        }
    }
}

extension FeedViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines), !query.isEmpty else {
            searchBar.text = nil
            searchBar.resignFirstResponder()

            resetSearchPhotos()
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
        viewModel.searchPhotos()
    }

    private func resetSearchPhotos() {
        viewModel.photoType = .curated
        viewModel.query = nil
        viewModel.fetchCuratedPhotos()
    }
}
