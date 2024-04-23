//
//  PhotoModel.swift
//  Gallery
//
//  Created by Анна Перехрест  on 2024/04/22.
//

import Foundation

private typealias Module = Feed
private typealias Model = Module.Model

extension Module {
    struct Model {
        var dataSource: [PhotoModel]

        init(dataSource: [PhotoModel]) {
            self.dataSource = dataSource
        }
    }
}

extension Model {
    struct PhotoModel: Identifiable {
        let id: Int
        let photographer: String
        let url: URL
        let alt: String

        init(id: Int, photographer: String, url: URL, alt: String) {
            self.id = id
            self.photographer = photographer
            self.url = url
            self.alt = alt
        }

        init(from photo: Photo) {
            self.id = photo.id
            self.photographer = photo.photographer
            self.url = photo.src.medium
            self.alt = photo.alt
        }
    }
}

extension Model {
    struct Pagination {
        var currentPage: Int
        var totalResult: Int

        init(currentPage: Int, totalResult: Int) {
            self.currentPage = currentPage
            self.totalResult = totalResult
        }
    }

    enum PhotoType {
        case curated
        case search
    }
}
