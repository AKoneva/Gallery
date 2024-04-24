//
//  NetworkTest.swift
//  GalleryTest
//
//  Created by Анна Перехрест  on 2024/04/24.
//
import XCTest
@testable import Gallery
import Alamofire

class NetworkManagerTests: XCTestCase {

    var networkManager: NetworkManager!

    override func setUp() {
        super.setUp()
        networkManager = NetworkManager.shared
    }

    override func tearDown() {
        networkManager = nil
        super.tearDown()
    }

    func testFetchCuratedPhotosSuccess() {
        // Given
        let page = 1
        let perPage = 10
        let expectedURL = "https://api.pexels.com/v1/curated?page=1&locale=en-US&per_page=10"
        let expectedResponse = PhotoResponce(photos: [], totalResults: 0)
        let expectation = XCTestExpectation(description: "Fetch curated photos success")

        // Mocking Alamofire's response
        let mockSession = MockSession() // Implement this mock as needed
        let networkManager = NetworkManager(session: mockSession)

        // When
        networkManager.fetchCuratedPhotos(page: page, perPage: perPage) { result in
            // Then
            switch result {
            case .success(let response):
                XCTAssertEqual(response, expectedResponse)
            case .failure(let error):
                XCTFail("Expected successful response, but got error: \(error)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }


    func testFetchCuratedPhotosFailure() {
        // Given
        let page = 1
        let perPage = 10
        let expectedURL = "https://api.pexels.com/v1/curated?page=1&locale=en-US&per_page=10"
        let expectedError = NetworkError.unknownError
        let expectation = XCTestExpectation(description: "Fetch curated photos failure")

        // Mocking Alamofire's response
        let interceptor = MockRequestInterceptor { request in
            XCTAssertEqual(request.url?.absoluteString, expectedURL)
            return (nil, AFError.invalidURL)
        }
        AF.session = Session(interceptor: interceptor)

        // When
        networkManager.fetchCuratedPhotos(page: page, perPage: perPage) { result in
            // Then
            switch result {
            case .success(_):
                XCTFail("Expected failure, but got successful response")
            case .failure(let error):
                XCTAssertEqual(error, expectedError)
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }
}

// MockRequestInterceptor to mock Alamofire requests
class MockRequestInterceptor: RequestInterceptor {
    let handler: (URLRequest) -> (Any?, AFError?)

    init(handler: @escaping (URLRequest) -> (Any?, AFError?)) {
        self.handler = handler
    }

    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        completion(.success(urlRequest))
    }

    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        completion(.doNotRetry)
    }

    func intercept(
        _ request: URLRequest,
        for session: Session,
        response: HTTPURLResponse?,
        data: Data?,
        error: Error?,
        completion: @escaping (URLRequest?, HTTPURLResponse?, Data?, Error?) -> Void
    ) {
        let (responseBody, responseError) = handler(request)
        if let error = responseError {
            completion(nil, nil, nil, error)
        } else {
            let httpResponse = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            completion(request, httpResponse, try! JSONSerialization.data(withJSONObject: responseBody!), nil)
        }
    }
}
