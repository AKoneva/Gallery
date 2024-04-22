//
//  PhotoSource.swift
//  Gallery
//
//  Created by Анна Перехрест  on 2024/04/20.
//

import Foundation

struct PhotoSource: Codable {
    let original: URL
    let large2x: URL
    let large: URL
    let medium: URL
    let small: URL
    let portrait: URL
    let landscape: URL
    let tiny: URL

    private enum CodingKeys: String, CodingKey {
        case original, large2x, large, medium, small, portrait, landscape, tiny
    }
}
