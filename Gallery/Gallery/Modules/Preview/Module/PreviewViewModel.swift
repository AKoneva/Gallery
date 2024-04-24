//
//  PreviewViewModel.swift
//  Gallery
//
//  Created by Анна Перехрест  on 2024/04/23.
//

import Foundation
import Combine

private typealias Module = Preview
private typealias ViewModel = Module.ViewModel

extension Module {
    class ViewModel {
        // MARK: - Published Properties
        @Published var photo: Model?
        @Published var errorMessage: String? = nil
        @Published var isLoading: Bool = false

        // MARK: - Other Properties
        var cancellables: Set<AnyCancellable> = []

        // MARK: - Initializer
        init(id: Int) {
            fetchPhoto(with: id)
        }

        // MARK: - Fetch Methods
        func fetchPhoto(with id: Int) {
            isLoading = true
            NetworkManager.shared.fetchPhoto(id: id) { result in
                switch result {
                    case .success(let responce):
                        self.handlePhotoResponse(responce)
                    case .failure(let error):
                        self.handleNetworkError(error)
                }
            }
        }

        // MARK: - Response Handling Methods
        private func handlePhotoResponse(_ response: Photo) {
            resetErrorAndLoading()
            photo = Model(from: response)
        }

        private func handleNetworkError(_ error: NetworkError) {
            resetErrorAndLoading()
            errorMessage = error.errorMessage
            print(errorMessage ?? NSLocalizedString("An unknown error occurred. Please try again later.", comment: ""))
        }

        // MARK: - Private Methods
        private func resetErrorAndLoading() {
            isLoading = false
            errorMessage = nil
        }
    }
}
