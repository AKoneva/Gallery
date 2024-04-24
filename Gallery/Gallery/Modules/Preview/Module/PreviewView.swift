//
//  PreviewView.swift
//  Gallery
//
//  Created by Анна Перехрест  on 2024/04/23.
//

import UIKit

private typealias Module = Preview
private typealias View = Module.View

extension Module {
    class View: UIViewController {
        // MARK: - IBOutlets
        @IBOutlet private weak var activityView: UIActivityIndicatorView!
        @IBOutlet private weak var scrollView: UIScrollView!
        @IBOutlet private weak var infoLabel: UILabel!
        @IBOutlet private weak var textBackground: UIView!
        @IBOutlet private weak var imageView: UIImageView!

        // MARK: - Properties
        private var viewModel: Module.ViewModel

        // MARK: - View Lifecycle
        init(id: Int) {
            viewModel = Module.ViewModel(id: id)
            super.init(nibName: "PreviewView", bundle: nil)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func viewDidLoad() {
            super.viewDidLoad()

            bindViewModel()
            configurateScrollView()
        }

        // MARK: - UI Setup
        private func configurateScrollView() {
            scrollView.delegate = self
            scrollView.contentSize = imageView.bounds.size

            let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
            doubleTapGestureRecognizer.numberOfTapsRequired = 2
            scrollView.addGestureRecognizer(doubleTapGestureRecognizer)
        }

        private func configurateUI() {
            guard let photo = viewModel.photo else { return }

            infoLabel.text = photo.alt + "\n" + NSLocalizedString("Author: ", comment: "")  + photo.photographer

            textBackground.layer.cornerRadius = 20
            textBackground.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

            showActivityView()
            imageView.kf.setImage(with: photo.url) { result in
                switch result {
                    case .success(_):
                        self.hideActivityView()
                    case .failure(_):
                        self.hideActivityView()
                        self.viewModel.errorMessage = NSLocalizedString("Couldnt load photo. Try again later" , comment: "")
                }
            }
        }

        // MARK: - ViewModel Binding
        private func bindViewModel() {
            viewModel.$photo
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    self?.hideActivityView()
                    self?.configurateUI()
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

        // MARK: - Activity Indicator
        private func showActivityView() {
            activityView.isHidden = false
            activityView.startAnimating()
        }

        private func hideActivityView() {
            activityView.isHidden = false
            activityView.stopAnimating()
        }

        // MARK: - Alert
        private func showErrorAlert(message: String) {
            let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""),
                                          message: NSLocalizedString(message, comment: ""),
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""),
                                          style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }

        @objc private func handleDoubleTap(_ sender: UITapGestureRecognizer) {
            let scale = min(scrollView.zoomScale * 2, scrollView.maximumZoomScale)
            if scale != scrollView.zoomScale {
                let tapPoint = sender.location(in: imageView)
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
}

// MARK: - UIScrollViewDelegate
extension View: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
