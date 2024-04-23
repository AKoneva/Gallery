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

        @IBOutlet weak var activityView: UIActivityIndicatorView!
        @IBOutlet weak var scrollView: UIScrollView!
        @IBOutlet weak var infoLabel: UILabel!
        @IBOutlet weak var textBackground: UIView!
        @IBOutlet weak var imageView: UIImageView!

        private var viewModel: Module.ViewModel

        init(id: Int) {
            viewModel = Module.ViewModel(id: id)
            super.init(nibName: "PreviewView", bundle: nil)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }


        // MARK: - View Lifecycle
        override func viewDidLoad() {
            super.viewDidLoad()

            bindViewModel()
            configurateScrollView()
//            addPinchGestureRecognizer()
//            addDoubleTapGestureRecognizer()
        }

        // MARK: - UI Setup
        private func configurateScrollView() {
            scrollView.delegate = self
            scrollView.contentSize = imageView.bounds.size

            // Ensure imageView is centered within scrollView
                let imageViewSize = imageView.bounds.size
                let scrollViewSize = scrollView.bounds.size
                let verticalInset = max(0, (scrollViewSize.height - imageViewSize.height) / 2)
                let horizontalInset = max(0, (scrollViewSize.width - imageViewSize.width) / 2)
                scrollView.contentInset = UIEdgeInsets(top: verticalInset, left: horizontalInset, bottom: verticalInset, right: horizontalInset)

        }
        private func configurateUI() {
            guard let photo = viewModel.photo else { return }

            infoLabel.text = photo.alt + "\n" + NSLocalizedString("\nAuthor: ", comment: "")  + photo.photographer
            textBackground.layer.cornerRadius = 20

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

        private func showErrorAlert(message: String) {
            let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""),
                                          message: NSLocalizedString(message, comment: ""),
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), 
                                          style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }

        private func addDoubleTapGestureRecognizer() {
            let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
            doubleTapGesture.numberOfTapsRequired = 2
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(doubleTapGesture)
        }

        private func addPinchGestureRecognizer() {
            let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(_:)))
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(pinchGesture)
        }

        @objc private func handlePinchGesture(_ gestureRecognizer: UIPinchGestureRecognizer) {
            guard let view = gestureRecognizer.view else { return }
               if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
                   let scale = gestureRecognizer.scale
                   if scale > 1.0 {
                       view.transform = view.transform.scaledBy(x: scale, y: scale)
                       gestureRecognizer.scale = 1.0
                   }
               }
        }

        @objc private func handleDoubleTap(_ gestureRecognizer: UITapGestureRecognizer) {
            guard let view = gestureRecognizer.view else { return }
            if gestureRecognizer.state == .ended {
                let scale: CGFloat = view.transform.a == 1.0 ? 2.0 : 1.0
                UIView.animate(withDuration: 0.3) {
                    view.transform = CGAffineTransform(scaleX: scale, y: scale)
                }
            }
        }
    }
}

extension View: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
