//
//  PhotoViewModel.swift
//  Gallery
//
//  Created by Анна Перехрест  on 2024/04/20.
//

import Foundation

class PhotoViewModel {
    var photos: [Photo] = []
    var errorMessage: String? = nil
    var currentPage: Int = 1
    var totalPages: Int = 1

    func fetchMockData()  {
        let mockPhotos: [Photo] = [
            Photo(id: 1,
                  width: 800,
                  height: 600,
                  url: URL(string: "https://picsum.photos/id/237/200/300")!,
                  photographer: "Anna",
                  alt: "Sample photo 1"),
            Photo(id: 2,
                  width: 300,
                  height: 500,
                  url: URL(string: "https://picsum.photos/id/44/300/500")!,
                  photographer: "Anna",
                  alt: "Sample photo 2")
            ,
            Photo(id: 2,
                  width: 300,
                  height: 500,
                  url: URL(string: "https://picsum.photos/id/44/300/500")!,
                  photographer: "Anna",
                  alt: "Sample photo 2"),
            Photo(id: 2,
                  width: 300,
                  height: 500,
                  url: URL(string: "https://picsum.photos/id/44/300/500")!,
                  photographer: "Anna",
                  alt: "Sample photo 2"),
            Photo(id: 2,
                  width: 300,
                  height: 500,
                  url: URL(string: "https://picsum.photos/id/44/300/500")!,
                  photographer: "Anna",
                  alt: "Sample photo 2"),
            Photo(id: 2,
                  width: 300,
                  height: 500,
                  url: URL(string: "https://picsum.photos/id/44/300/500")!,
                  photographer: "Anna",
                  alt: "Sample photo 2"),
            Photo(id: 2,
                  width: 300,
                  height: 500,
                  url: URL(string: "https://picsum.photos/id/44/300/500")!,
                  photographer: "Anna",
                  alt: "Sample photo 2")
        ]

        photos =  mockPhotos
    }
}
