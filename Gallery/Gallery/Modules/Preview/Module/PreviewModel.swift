//
//  PreviewModel.swift
//  Gallery
//
//  Created by Анна Перехрест  on 2024/04/23.
//

import Foundation

private typealias Module = Preview
private typealias Model = Module.Model

extension Module {
    struct Model {
        let id: Int
        let photographer: String
        let url: URL
        let alt: String

        init(from photo: Photo) {
            self.id = photo.id
            self.photographer = photo.photographer
            self.url = photo.src.original
            self.alt = photo.alt
        }
    }
}
