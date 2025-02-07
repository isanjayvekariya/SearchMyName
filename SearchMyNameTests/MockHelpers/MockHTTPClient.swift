//
//  MockHTTPClient.swift
//  SearchMyName
//
//  Created by Sanjay Vekariya on 2/6/25.
//

import Foundation
@testable import SearchMyName

final class MockHTTPClient: URLSessionHTTPClient {
    var mockData: Data?
    var mockError: Error?
    
    override func fetch(url: URL) async throws -> Data {
        if let error = mockError {
            throw error
        }
        return mockData ?? Data()
    }
}
