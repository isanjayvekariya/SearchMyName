//
//  MockURLBuilder.swift
//  SearchMyName
//
//  Created by Sanjay Vekariya on 2/6/25.
//

import Foundation
@testable import SearchMyName

final class MockURLBuilder: URLBuilderProtocol {
    var shouldFail = false
    var capturedBaseURL: String?
    var capturedPath: String?
    var capturedQueryItems: [URLQueryItem]?
    
    func buildURL(baseURL: String, path: String, queryItems: [URLQueryItem]) throws -> URL {
        capturedBaseURL = baseURL
        capturedPath = path
        capturedQueryItems = queryItems
        
        if shouldFail {
            throw NetworkError.invalidURL
        }
        
        return URL(string: "https://test.com")!
    }
}
