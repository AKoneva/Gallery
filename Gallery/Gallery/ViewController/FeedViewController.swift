//
//  ViewController.swift
//  Gallery
//
//  Created by Анна Перехрест  on 2024/04/19.
//

import UIKit

class FeedViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!

    private let viewModel = PhotoViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionViewSetUp()
    }

    func collectionViewSetUp() {
        collectionView.dataSource = self
        collectionView.delegate = self

        collectionLayoutSetUp()

        viewModel.fetchMockData()
    }

    func collectionLayoutSetUp() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 4
        collectionView
            .setCollectionViewLayout(layout, animated: true)
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
}
