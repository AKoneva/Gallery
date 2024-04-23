//
//  PhotoCollectionCell.swift
//  Gallery
//
//  Created by Анна Перехрест  on 2024/04/23.
//

import UIKit
import Kingfisher

class PhotoCollectionCell: UICollectionViewCell {

    @IBOutlet weak var textBackground: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
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
        nameLabel.text = photo.alt
        imageView.kf.setImage(with: photo.url)
    }
}

extension PhotoCollectionCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
