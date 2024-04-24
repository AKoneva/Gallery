//
//  PhotoCollectionCell.swift
//  Gallery
//
//  Created by Анна Перехрест  on 2024/04/23.
//

import UIKit
import Kingfisher

class PhotoCollectionCell: UICollectionViewCell {
    // MARK: - IBOutlets
    @IBOutlet weak var textBackground: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    // MARK: - View Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    // MARK: - Private Methods
    private func setupUI() {
        textBackground.layer.cornerRadius = 20
        textBackground.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }

    // MARK: - Public Methods
    func configure(with photo: Feed.Model.PhotoModel) {
        if photo.alt.isEmpty {
            nameLabel.text = NSLocalizedString("Author: ", comment: "")  + photo.photographer
        } else {
            nameLabel.text = photo.alt
        }

        imageView.kf.setImage(with: photo.url)
    }
}

extension PhotoCollectionCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
