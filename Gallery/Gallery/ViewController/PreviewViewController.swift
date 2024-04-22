//
//  PreviewViewController.swift
//  Gallery
//
//  Created by Анна Перехрест  on 2024/04/20.
//

import UIKit
import Kingfisher

class PreviewViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var photoInfoLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var textBackground: UIView!
    @IBOutlet weak var scrollView: UIScrollView!

    // MARK: - Properties
    var photo: Photo?

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollViewConfiguration()
        uiConfiguration()
    }

    // MARK: - UI Setup
    private func scrollViewConfiguration() {
        scrollView.delegate = self
        scrollView.maximumZoomScale = 6
    }

    private func uiConfiguration() {
        guard let name = photo?.alt, let photographer = photo?.photographer, let url = photo?.src.original else { return }

        photoInfoLabel.text = name + "\nAuthor: " + photographer
        textBackground.layer.cornerRadius = 20

        showActivityView()
        photoImageView.kf.setImage(with: url) { result in
            switch result {
                case .success(_):
                    self.hideActivityView()
                case .failure(_):
                    self.hideActivityView()
                    let alert = UIAlertController(title: "Error", message: "Couldn`t load photot. Try again later", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
            }
        }
    }

    // MARK: - Activity Indicator
    private func showActivityView() {
        activityView.isHidden = false
        activityView.startAnimating()
    }

    private func hideActivityView() {
        activityView.isHidden = false
        activityView.stopAnimating()
    }
}

// MARK: - UIScrollViewDelegate
extension PreviewViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return photoImageView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView.zoomScale == scrollView.minimumZoomScale {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }

    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}
