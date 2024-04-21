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
    @Published var isLoading: Bool = false
    var query: String? = nil
    var totalResults: Int = 1
    var currentPage: Int = 1

    private var hasNextPage: Bool {
        return photos.count < totalResults
    }

    private var hasPrevPage: Bool {
        return currentPage > 1
    }

    private func resetCurrentPageAndPhotos() {
        currentPage = 1
        photos = []
    }
}

extension PhotoViewModel {
    func fetchNextPage() {
        currentPage += 1
        fetchPhotos()
    }

    func fetchPrevPage() {
        currentPage -= 1
        fetchPhotos()
    }

    func fetchPhotos() {
        isLoading = true
        switch photoType {
            case .curated:
                fetchCuratedPhotos()
            case .search:
                searchPhotos()
        }
    }

    private func fetchCuratedPhotos() {
        NetworkManager.shared.fetchCuratedPhotos(page: currentPage) { result in
            switch result {
                case .success(let responce):
                    self.handleCuratedResponse(responce)
                case .failure(let error):
                    self.handleNetworkError(error)
            }
        }
    }

    private func searchPhotos() {
        guard let query = query else { return }

        NetworkManager.shared.searchPhotos(query: query, page: currentPage) { result in
            switch result {
                case .success(let responce):
                    self.handleSearchResponse(responce)
                case .failure(let error):
                    self.handleNetworkError(error)
            }
        }
    }

    private func handleCuratedResponse(_ response: CuratedPhotosResponse) {
        isLoading = false
        errorMessage = nil
        photos.append(contentsOf: response.photos)
        totalResults = response.totalResults
        print("Total Results: \(response.totalResults)\nPage: \(response.page)\nPhotos: \(response.photos)")
    }

    private func handleSearchResponse(_ response: SearchResponse) {
        isLoading = false
        errorMessage = nil
        photos.append(contentsOf: response.photos)
        totalResults = response.totalResults
        print("Total Results: \(response.totalResults)\nPage: \(response.page)\nPhotos: \(response.photos)")
    }

    private func handleNetworkError(_ error: NetworkError) {
        isLoading = false
        errorMessage = error.errorMessage
        print(errorMessage ?? "Unknown error")
    }
}
