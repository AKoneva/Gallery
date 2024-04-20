//
//  PreviewViewController.swift
//  Gallery
//
//  Created by Анна Перехрест  on 2024/04/20.
//

import UIKit
import Kingfisher

class PreviewViewController: UIViewController {
    @IBOutlet weak var photoInfoLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var textBackground: UIView!

    var photo: Photo?

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }

    func configureUI() {
        guard let name = photo?.alt, let photographer = photo?.photographer, let url = photo?.url else { return }

        photoInfoLabel.text = name + "\nAuthor: " + photographer
        textBackground.layer.cornerRadius = 20

        photoImageView.kf.setImage(with: url)
    }
}
