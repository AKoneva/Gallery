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

    func fetchCuratedPhotos(completion: @escaping (Result<[Photo], Error>) -> Void) {
        let urlString = "\(baseURL)/curated?per_page=20"

        let headers: HTTPHeaders = ["Authorization": apiKey]

        AF.request(urlString, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(CuratedPhotosResponse.self, from: data)
                    completion(.success(result.photos))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
