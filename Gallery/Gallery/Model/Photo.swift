//
//  Photo.swift
//  Gallery
//
//  Created by Анна Перехрест  on 2024/04/20.
//

import Foundation

struct Photo: Decodable {
    let id: Int
    let width: Int
    let height: Int
    let url: URL
    let photographer: String
//    let photographerUrl: URL
//    let photographerId: Int
//    let avgColor: String
//    let src: PhotoSource
//    let liked: Bool
    let alt: String

//    private enum CodingKeys: String, CodingKey {
//        case id, width, height, url, photographer, src, liked, alt
//        case photographerUrl = "photographer_url"
//        case photographerId = "photographer_id"
//        case avgColor = "avg_color"
//    }
}
