//
//  NetworkManager.swift
//  Gallery
//
//  Created by Анна Перехрест  on 2024/04/20.
//
import Foundation
import Alamofire

// MARK: - NetworkError Enum
enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
    case timeout
    case noInternetConnection
    case serverError(String)
    case unknownError

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
            case .timeout:
                return "Request timed out. Please try again later."
            case .noInternetConnection:
                return "No internet connection. Please check your network settings."
            case .unknownError:
                return "An unknown error occurred. Please try again later."
        }
    }
}

// MARK: - NetworkManager Class
class NetworkManager {
    static let shared = NetworkManager()

    private let baseURL = "https://api.pexels.com/v1"
    private let apiKey = "hqmcg1glWtJI68faEqyU4XehCsolcfBqlU8WnH7uflPCceBps5UYL7wB"

    private init() {}

    // MARK: - Public Methods
    func fetchCuratedPhotos(page: Int = 1, perPage: Int = 50, completion: @escaping (Result<CuratedPhotosResponse, NetworkError>) -> Void) {
        let endpoint = "\(baseURL)/curated"
        let parameters: [String: Any] = ["page": page, "locale": getLocale(), "per_page": perPage]
        let headers: HTTPHeaders = ["Authorization": apiKey]

        requestDecodable(endpoint: endpoint, parameters: parameters, headers: headers, completion: completion)
    }

    func searchPhotos(query: String, page: Int = 1, perPage: Int = 50, completion: @escaping (Result<SearchResponse, NetworkError>) -> Void) {
        
        let endpoint = "\(baseURL)/search"
        let parameters: [String: Any] = ["query": query,
                                         "locale": getLocale(),
                                         "page": page,
                                         "per_page": perPage]
        let headers: HTTPHeaders = ["Authorization": apiKey]

        requestDecodable(endpoint: endpoint, parameters: parameters, headers: headers, completion: completion)
    }

    func fetchPhoto(id: Int, locale: String = "en-US", completion: @escaping (Result<Photo, NetworkError>) -> Void) {
        let endpoint = "\(baseURL)/photos/\(id)"
           let parameters: [String: Any] = ["locale": getLocale()]


        let headers: HTTPHeaders = ["Authorization": apiKey]

        requestDecodable(endpoint: endpoint, parameters: parameters, headers: headers, completion: completion)
    }

    // MARK: - Private Methods
    private func getLocale() -> String {
        let languageCode = Locale.current.language.languageCode?.identifier ?? "en"
        switch languageCode {
            case "ja":
                return "ja-JP"
            default:
                return "en-US"
        }
    }

    private func requestDecodable<T: Codable>(endpoint: String, parameters: Parameters?, headers: HTTPHeaders?, completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let url = URL(string: endpoint) else {
            completion(.failure(.invalidURL))
            return
        }

        AF.request(url, parameters: parameters, headers: headers)
            .validate()
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let result):
                    print(result)
                    completion(.success(result))
                case .failure(let error):
                    if let afError = error as? AFError {
                        switch afError {
                        case .responseValidationFailed(let reason):
                            switch reason {
                            case .unacceptableStatusCode(_):
                                completion(.failure(.invalidResponse))
                            default:
                                completion(.failure(.unknownError))
                            }
                        default:
                            completion(.failure(.unknownError))
                        }
                    } else {
                        // Handle URLError
                        let nsError = error as NSError
                        if nsError.domain == NSURLErrorDomain {
                            switch nsError.code {
                            case NSURLErrorTimedOut:
                                completion(.failure(.timeout))
                            case NSURLErrorNotConnectedToInternet:
                                completion(.failure(.noInternetConnection))
                            default:
                                completion(.failure(.unknownError))
                            }
                        } else {
                            completion(.failure(.unknownError))
                        }
                    }
                }
            }
    }
}

