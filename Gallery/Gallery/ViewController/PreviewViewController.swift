//
//  PreviewViewController.swift
//  Gallery
//
//  Created by Анна Перехрест  on 2024/04/20.
//

import UIKit
import Kingfisher

class PreviewViewController: UIViewController {
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var photoInfoLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var textBackground: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    var photo: Photo?

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpZooming()
        configureUI()
    }

    func setUpZooming() {
        scrollView.delegate = self
        scrollView.maximumZoomScale = 4.0
        let recognizer = UITapGestureRecognizer(target: self,
                                                action: #selector(onDoubleTap(_:)))
        recognizer.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(recognizer)

    }

    func configureUI() {
        guard let name = photo?.alt, let photographer = photo?.photographer, let url = photo?.src.original else { return }

        photoInfoLabel.text = name + "\nAuthor: " + photographer
        textBackground.layer.cornerRadius = 20

        showActivityView()
        photoImageView.kf.setImage(with: url) { result in
            switch result {
                case .success(let image):
                    self.hideActivityView()
                case .failure(let error):
                    self.hideActivityView()
                    let alert = UIAlertController(title: "Error", message: "Couldn`t load photot. Try again later", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
            }
        }
    }

    private func showActivityView() {
        activityView.isHidden = false
        activityView.startAnimating()
    }

    private func hideActivityView() {
        activityView.isHidden = false
        activityView.stopAnimating()
    }

    @objc func onDoubleTap(_ sender: UITapGestureRecognizer) {
            let scale = min(scrollView.zoomScale * 2, scrollView.maximumZoomScale)

            if scale != scrollView.zoomScale {
                let tapPoint = sender.location(in: photoImageView)
                let size = CGSize(width: scrollView.frame.size.width / scale,
                                  height: scrollView.frame.size.height / scale)
                let origin = CGPoint(x: tapPoint.x - size.width / 2,
                                     y: tapPoint.y - size.height / 2)
                scrollView.zoom(to: CGRect(origin: origin, size: size), animated: true)
            }
            else {
                scrollView.zoom(to: scrollView.frame, animated: true)
            }
        }
}

extension PreviewViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
          return photoImageView
      }
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        // Show navigation bar when zooming ends
        if scrollView.zoomScale == scrollView.minimumZoomScale {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}
