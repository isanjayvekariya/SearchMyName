//
//  URLBuilder.swift
//  SearchMyName
//
//  Created by Sanjay Vekariya on 2/6/25.
//

import Foundation

protocol URLBuilderProtocol {
    func buildURL(baseURL: String, path: String, queryItems: [URLQueryItem]) throws -> URL
}

final class URLBuilder: URLBuilderProtocol {
    func buildURL(baseURL: String, path: String, queryItems: [URLQueryItem]) throws -> URL {
        guard let _ = URL(string: baseURL) else {
            throw NetworkError.invalidURL
        }
        
        let queryString = queryItems
            .compactMap { item in
                guard let value = item.value?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return nil }
                return "\(item.name)=\(value)"
            }
            .joined(separator: "&")
            
        let urlString = "\(baseURL)\(path)?\(queryString)"
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        return url
    }
}

struct APIConfig {
    let baseURL: String
    let characterPath: String
    
    static let production = APIConfig(
        baseURL: "https://rickandmortyapi.com/api",
        characterPath: "/character"
    )
}
