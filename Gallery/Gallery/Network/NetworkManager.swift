//
//  NetworkManager.swift
//  Gallery
//
//  Created by Анна Перехрест  on 2024/04/20.
//
import Foundation
import Alamofire

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
    case serverError(String)

    var errorMessage: String {
            switch self {
            case .invalidURL:
                return "Invalid URL. Please try again later."
            case .invalidResponse:
                return "Invalid response from the server. Please try again later."
            case .decodingError:
                return "Error decoding the response. Please try again later."
            case .serverError(let message):
                return "Server error: \(message)"
            }
        }
}

class NetworkManager {
    static let shared = NetworkManager()

    private let baseURL = "https://api.pexels.com/v1"
    private let apiKey = "hqmcg1glWtJI68faEqyU4XehCsolcfBqlU8WnH7uflPCceBps5UYL7wB"

    private init() {}

    func fetchCuratedPhotos(page: Int = 1, perPage: Int = 50, completion: @escaping (Result<CuratedPhotosResponse, NetworkError>) -> Void) {
        let endpoint = "\(baseURL)/curated"
        let parameters: [String: Any] = ["page": page, "per_page": perPage]
        let headers: HTTPHeaders = ["Authorization": apiKey]

        requestDecodable(endpoint: endpoint, parameters: parameters, headers: headers, completion: completion)
    }

    func searchPhotos(query: String, page: Int = 1, perPage: Int = 50, completion: @escaping (Result<SearchResponse, NetworkError>) -> Void) {
        let endpoint = "\(baseURL)/search"
        let parameters: [String: Any] = ["query": query, "page": page, "per_page": perPage]
        let headers: HTTPHeaders = ["Authorization": apiKey]

        requestDecodable(endpoint: endpoint, parameters: parameters, headers: headers, completion: completion)
    }

    private func requestDecodable<T: Decodable>(endpoint: String, parameters: Parameters?, headers: HTTPHeaders?, completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let url = URL(string: endpoint) else {
            completion(.failure(.invalidURL))
            return
        }

        AF.request(url, parameters: parameters, headers: headers)
            .validate()
            .responseDecodable(of: T.self) { response in
                switch response.result {
                    case .success(let result):
                        completion(.success(result))
                    case .failure(let error):
                        if let statusCode = response.response?.statusCode {
                            completion(.failure(.serverError("Server error with status code: \(statusCode)")))
                        } else {
                            completion(.failure(.decodingError))
                        }
                }
            }
    }
}

