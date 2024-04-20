//
//  PhotoViewModel.swift
//  Gallery
//
//  Created by Анна Перехрест  on 2024/04/20.
//

import Foundation
import Combine

class PhotoViewModel {
    @Published var photos: [Photo] = []
    @Published var errorMessage: String? = nil
    @Published var currentPage: Int = 1
    @Published var totalPages: Int = 1

}

extension PhotoViewModel {
    func fetchCuratedPhotos() {
        NetworkManager.shared.fetchCuratedPhotos { result in
            switch result {
            case .success(let photos):
                    self.errorMessage = nil
                    self.photos = photos
            case .failure(let error):
                    self.errorMessage = "Error fetching curated photos: \(error)"
                    print("Error fetching curated photos: \(error)")
            }
        }
    }
}
