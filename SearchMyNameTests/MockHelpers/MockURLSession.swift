//
//  MockURLSession.swift
//  SearchMyName
//
//  Created by Sanjay Vekariya on 2/6/25.
//

import Foundation
@testable import SearchMyName

final class MockURLSession: URLSessionProtocol {
    var data: Data?
    var response: URLResponse?
    var error: Error?
    
    func data(from url: URL) async throws -> (Data, URLResponse) {
        if let error = error {
            throw error
        }
        
        return (
            data ?? Data(),
            response ?? HTTPURLResponse(
                url: url,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
        )
    }
}
