//
//  MockHTTPClient.swift
//  SearchMyName
//
//  Created by Sanjay Vekariya on 2/6/25.
//

import Foundation
@testable import SearchMyName

final class MockHTTPClient: HTTPClient {
    var result: Result<Data, Error>?
    var capturedURL: URL?
    
    func fetch(url: URL) async throws -> Data {
        capturedURL = url
        guard let result = result else {
            throw NetworkError.noData
        }
        return try result.get()
    }
}
