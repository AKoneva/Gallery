//
//  PhotoCollectionViewCell.swift
//  Gallery
//
//  Created by Анна Перехрест  on 2024/04/20.
//

import UIKit
import Kingfisher

class PhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var photoInfoLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var textBackground: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()

        textBackground.layer.cornerRadius = 20
        textBackground.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }

    func configure(with photo: Photo) {
        photoInfoLabel.text = photo.alt
        photoImageView.kf.setImage(with: photo.src.medium)
    }
}
