//
//  PhotoViewModel.swift
//  Gallery
//
//  Created by Анна Перехрест  on 2024/04/20.
//

import Foundation
import Combine

enum PhotoType {
    case curated
    case search
}

class PhotoViewModel {
    @Published var photoType: PhotoType = .curated {
        didSet {
            resetCurrentPageAndPhotos()
        }
    }

    @Published var photos: [Photo] = []
    @Published var errorMessage: String? = nil
    var query: String? = nil
    var totalPages: Int = 1
    var hasNextPage: Bool = false
    var hasPrevPage: Bool = false
    var totalResults: Int = 1
    var currentPage: Int = 1

    private func resetCurrentPageAndPhotos() {
        currentPage = 1
        photos = []
    }
}

extension PhotoViewModel {
    func fetchCuratedPhotos() {
        NetworkManager.shared.fetchCuratedPhotos(page: currentPage) { result in
            switch result {
                case .success(let curatedPhotos):
                    self.errorMessage = nil
                    self.photos.append(contentsOf: curatedPhotos.photos)
                    self.currentPage = curatedPhotos.page
                    self.hasNextPage = curatedPhotos.nextPage != nil
                    self.hasPrevPage = curatedPhotos.prevPage != nil
                case .failure(let error):
                    self.errorMessage = "Error fetching curated photos: \(error)"
                    print("Error fetching curated photos: \(error)")
            }
        }
    }

    func searchPhotos() {
        guard let query = query else { return }

        NetworkManager.shared.searchPhotos(query: query, page: currentPage) { searchResult in
            switch searchResult {
                case .success(let response):
                    self.errorMessage = nil
                    self.photos.append(contentsOf: response.photos)
                    self.totalResults = response.totalResults
                case .failure(let error):
                    self.errorMessage = "Error fetching curated photos: \(error)"
                    print("Error fetching curated photos: \(error)")
            }
        }
    }

    func fetchNextPage() {
        switch photoType {
            case .curated:
                guard hasNextPage else { return }

                currentPage += 1
                fetchCuratedPhotos()
            case .search:
                if photos.count < totalResults {
                    currentPage += 1
                    searchPhotos()
                } else { return }
        }
    }

    func fetchPrevPage() {
        switch photoType {
            case .curated:
                guard hasPrevPage else { return }
                currentPage -= 1
                fetchCuratedPhotos()
            case .search:
                guard currentPage > 1 else { return }
                currentPage -= 1
                searchPhotos()
        }
    }

}
