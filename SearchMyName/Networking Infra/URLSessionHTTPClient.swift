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

protocol URLSessionDataTasking {
    func data(from url: URL) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionDataTasking {
    func data(from url: URL) async throws -> (Data, URLResponse) {
        try await data(from: url, delegate: nil)
    }
}

class URLSessionHTTPClient: HTTPClient {
    private let session: URLSessionDataTasking
    
    init(session: URLSessionDataTasking = URLSession.shared) {
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

enum NetworkError: Error, Equatable {
    case invalidURL
    case noData
    case decodingError
    case httpError(Int)
    case unknown(Error)
    
    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        lhs.localizedDescription == rhs.localizedDescription
    }
}
