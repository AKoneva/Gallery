//
//  SearchResponse.swift
//  Gallery
//
//  Created by Анна Перехрест  on 2024/04/20.
//

import Foundation

struct SearchResponse: Decodable {
    let totalResults: Int
    let page: Int
    let perPage: Int
    let photos: [Photo]

    private enum CodingKeys: String, CodingKey {
        case page, photos
        case totalResults = "total_results"
        case perPage = "per_page"
    }
}
