//
//  PhotoViewModel.swift
//  Gallery
//
//  Created by Анна Перехрест  on 2024/04/20.
//

import Foundation
import Combine
// TO DO: fix pagination for curated photos, add enum and refactor code.
class PhotoViewModel {
    @Published var photos: [Photo] = []
    @Published var errorMessage: String? = nil
    @Published var currentPage: Int = 1
    @Published var query: String? = nil
    var totalPages: Int = 1
    var hasNextPage: Bool = false
    var hasPrevPage: Bool = false
    var totalResults: Int = 1
}

extension PhotoViewModel {
    func fetchCuratedPhotos() {
        NetworkManager.shared.fetchCuratedPhotos(page: currentPage) { result in
            switch result {
                case .success(let curatedPhotos):
                    self.errorMessage = nil
                    if curatedPhotos.page == 1 {
                        self.photos = []
                        self.photos = curatedPhotos.photos
                    } else {
                        self.photos.append(contentsOf: curatedPhotos.photos)
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

    func fetchNextPage(isSearch: Bool = false) {
        if isSearch {
            if photos.count < totalResults {
                currentPage += 1
                searchPhotos()
            } else { return }
        } else {
            guard hasNextPage else { return }
            
            currentPage += 1
            fetchCuratedPhotos()
        }
    }

    func fetchPrevPage() {
        guard hasPrevPage else { return }
        currentPage -= 1
        fetchCuratedPhotos()
    }

    func searchPhotos() {
        guard let query = query else { return }

        NetworkManager.shared.searchPhotos(query: query, page: currentPage) { searchResult in
            switch searchResult {
                case .success(let response):
                    self.errorMessage = nil
                    if response.page == 1 {
                        self.photos = []
                        self.photos = response.photos
                    } else {
                        self.photos.append(contentsOf: response.photos)
                        print(self.photos.count)
                    }
                    self.totalResults = response.totalResults
                case .failure(let error):
                    self.errorMessage = "Error fetching curated photos: \(error)"
                    print("Error fetching curated photos: \(error)")
            }
        }
    }
}
