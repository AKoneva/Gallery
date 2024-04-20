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
    var totalPages: Int = 1
    var hasNextPage: Bool = false
    var hasPrevPage: Bool = false

}

extension PhotoViewModel {
    func fetchCuratedPhotos() {
        NetworkManager.shared.fetchCuratedPhotos(page: currentPage) { result in
            switch result {
                case .success(let curatedPhotos):
                    self.errorMessage = nil
                    if !self.photos.isEmpty {
                        self.photos.append(contentsOf: curatedPhotos.photos)
                    } else {
                        self.photos = curatedPhotos.photos
                    }
                    self.currentPage = curatedPhotos.page
                    self.hasNextPage = curatedPhotos.nextPage != nil
                    self.hasPrevPage = curatedPhotos.prevPage != nil
                case .failure(let error):
                    self.errorMessage = "Error fetching curated photos: \(error)"
                    print("Error fetching curated photos: \(error)")
            }
        }
    }

    func fetchNextPage() {
        guard hasNextPage else { return }
        currentPage += 1
        fetchCuratedPhotos()
    }

    func fetchPrevPage() {
        guard hasPrevPage else { return }
        currentPage -= 1
        fetchCuratedPhotos()
    }
}
