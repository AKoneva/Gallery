//
//  ViewModel.swift
//  Gallery
//
//  Created by Анна Перехрест  on 2024/04/22.
//

import Foundation
import Combine

private typealias Module = Feed
private typealias ViewModel = Module.ViewModel

extension Module {
    class ViewModel {
        // MARK: - Published Properties
        @Published var photoType: Model.PhotoType = .curated {
            didSet {
                resetCurrentPageAndPhotos()
            }
        }
        @Published var photos = Model(dataSource: [])
        @Published var errorMessage: String? = nil
        @Published var isLoading: Bool = false

        // MARK: - Other Properties
        var query: String? = nil
        var pagination = Model.Pagination(currentPage: 1, totalResult: 0)
        var cancellables: Set<AnyCancellable> = []

        // MARK: - Computed Properties
        private var hasNextPage: Bool {
            return photos.dataSource.count < pagination.totalResult
        }

        private var hasPrevPage: Bool {
            return pagination.currentPage > 1
        }

        // MARK: - Helper Methods
        private func resetCurrentPageAndPhotos() {
            pagination.currentPage = 1
            pagination.totalResult = 0
            photos.dataSource = []
        }

        private func resetErrorAndLoading() {
            isLoading = false
            errorMessage = nil
        }
    }
}
// MARK: - Fetch Methods
extension ViewModel {
    func fetchNextPage() {
        if hasNextPage {
            pagination.currentPage += 1
            fetchPhotos()
        }
    }

    func fetchPrevPage() {
        if hasPrevPage {
            pagination.currentPage -= 1
            fetchPhotos()
        }
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

    // MARK: - Network Requests
    private func fetchCuratedPhotos() {
        NetworkManager.shared.fetchCuratedPhotos(page: pagination.currentPage) { result in
            switch result {
                case .success(let responce):
                    self.handleResponse(responce)
                case .failure(let error):
                    self.handleNetworkError(error)
            }
        }
    }

    private func searchPhotos() {
        guard let query = query else { return }
        NetworkManager.shared.searchPhotos(query: query, page: pagination.currentPage) { result in
            switch result {
                case .success(let responce):
                    self.handleResponse(responce)
                case .failure(let error):
                    self.handleNetworkError(error)
            }
        }
    }

    // MARK: - Response Handlers
    private func handleResponse(_ response: PhotoResponce) {
        resetErrorAndLoading()
        for photo in response.photos {
            let photo: Photo = photo
            let photoModel = Module.Model.PhotoModel(from: photo)
            photos.dataSource.append(photoModel)
        }
        pagination.totalResult = response.totalResults
    }

    private func handleNetworkError(_ error: NetworkError) {
        isLoading = false
        errorMessage = NSLocalizedString(error.errorMessage, comment: "")
        print(errorMessage ?? NSLocalizedString("An unknown error occurred. Please try again later.", comment: ""))
    }
}

