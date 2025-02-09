//
//  MockURLSession.swift
//  SearchMyName
//
//  Created by Sanjay Vekariya on 2/6/25.
//

import Foundation
@testable import SearchMyName

final class MockURLSession: URLSessionDataTasking {
    var data: Data?
    var response: URLResponse?
    var error: Error?
    private(set) var lastURL: URL?
    
    func data(from url: URL) async throws -> (Data, URLResponse) {
        lastURL = url
        
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
