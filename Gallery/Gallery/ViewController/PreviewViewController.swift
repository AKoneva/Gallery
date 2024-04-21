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

    var photo: Photo?

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
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
}
