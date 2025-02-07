//
//  HTTPClient.swift
//  SearchMyName
//
//  Created by Sanjay Vekariya on 2/6/25.
//

import Foundation

protocol HTTPClient {
    func fetch(url: URL) async throws -> Data
}

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case httpError(Int)
    case unknown(Error)
}

class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetch(url: URL) async throws -> Data {
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.noData
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.httpError(httpResponse.statusCode)
        }
        
        return data
    }
}
