//
//  MockURLBuilder.swift
//  SearchMyName
//
//  Created by Sanjay Vekariya on 2/6/25.
//

import Foundation
@testable import SearchMyName

final class MockURLBuilder: URLBuilderProtocol {
    var mockURL: URL?
    var capturedQueryItems: [URLQueryItem]?
    var shouldFail = false
    
    func buildURL(baseURL: String, path: String, queryItems: [URLQueryItem]) throws -> URL {
        capturedQueryItems = queryItems
        if shouldFail {
            throw NetworkError.invalidURL
        }
        return mockURL ?? URL(string: "https://test.com")!
    }
}
