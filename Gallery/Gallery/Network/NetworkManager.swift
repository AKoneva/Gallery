//
//  NetworkManager.swift
//  Gallery
//
//  Created by Анна Перехрест  on 2024/04/20.
//

import Foundation
import Alamofire

class NetworkManager {
    static let shared = NetworkManager()

    private let baseURL = "https://api.pexels.com/v1"
    private let apiKey = "hqmcg1glWtJI68faEqyU4XehCsolcfBqlU8WnH7uflPCceBps5UYL7wB"

    private init() {}

    func fetchCuratedPhotos(page: Int = 1,
                            perPage: Int = 50,
                            completion: @escaping (Result<CuratedPhotosResponse, Error>) -> Void) {
        let endpoint = baseURL + "/curated"

        let parameters: [String: Any] = [
            "page": page,
            "per_page": perPage
        ]

        let headers: HTTPHeaders = ["Authorization": apiKey]

        AF.request(endpoint, parameters: parameters, headers: headers)
            .responseDecodable(of: CuratedPhotosResponse.self) { response in
                switch response.result {
                    case .success(let curatedPhotos):
                        completion(.success(curatedPhotos))
                    case .failure(let error):
                        completion(.failure(error))
                }
            }
    }

    func searchPhotos(query: String, page: Int = 1, perPage: Int = 50, completion: @escaping (Result<SearchResponse, Error>) -> Void) {
        let endpoint = baseURL + "/search"
        let parameters: [String: Any] = [
            "query": query,
            "page": page,
            "per_page": perPage
        ]

        let headers: HTTPHeaders = [
            "Authorization": apiKey
        ]

        AF.request(endpoint, parameters: parameters, headers: headers)
            .responseDecodable(of: SearchResponse.self) { response in
                switch response.result {
                    case .success(let searchResponse):
                        completion(.success(searchResponse))
                    case .failure(let error):
                        completion(.failure(error))
                }
            }
    }
}
