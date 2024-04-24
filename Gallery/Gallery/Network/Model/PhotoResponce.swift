//
//  PhotoResponce.swift
//  Gallery
//
//  Created by Анна Перехрест  on 2024/04/24.
//

import Foundation

struct PhotoResponce: Codable {
    let totalResults: Int
    let page: Int
    let perPage: Int
    let photos: [Photo]

    private enum CodingKeys: String, CodingKey {
        case page, photos
        case totalResults = "total_results"
        case perPage = "per_page"
    }

    init(totalResults: Int, page: Int, perPage: Int, photos: [Photo]) {
        self.totalResults = totalResults
        self.page = page
        self.perPage = perPage
        self.photos = photos
    }
}
