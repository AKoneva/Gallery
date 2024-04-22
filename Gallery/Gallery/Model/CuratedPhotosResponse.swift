//
//  CuratedPhotosResponse.swift
//  Gallery
//
//  Created by Анна Перехрест  on 2024/04/20.
//

import Foundation

struct CuratedPhotosResponse: Codable {
    let page: Int
    let perPage: Int
    let totalResults: Int
    let nextPage: URL?
    let prevPage: URL?
    let photos: [Photo]

    private enum CodingKeys: String, CodingKey {
        case page, photos
        case perPage = "per_page"
        case totalResults = "total_results"
        case nextPage = "next_page"
        case prevPage = "prev_page"
    }
}
