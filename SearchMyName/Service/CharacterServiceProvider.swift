//
//  CharacterServiceProvider.swift
//  SearchMyName
//
//  Created by Sanjay Vekariya on 2/6/25.
//

import Foundation

protocol CharacterServiceProviding {
    func searchCharacters(query: String, filters: [URLQueryItem]) async throws -> [Character]
}

final class CharacterServiceProvider: CharacterServiceProviding {
    private let httpClient: HTTPClient
    private let urlBuilder: URLBuilding
    private let config: APIConfig
    
    init(
        httpClient: HTTPClient = URLSessionHTTPClient(),
        urlBuilder: URLBuilding = URLBuilder(),
        config: APIConfig = .production
    ) {
        self.httpClient = httpClient
        self.urlBuilder = urlBuilder
        self.config = config
    }
    
    func searchCharacters(query: String, filters: [URLQueryItem] = []) async throws -> [Character] {
        var queryItems = [URLQueryItem(name: "name", value: query)]
        queryItems.append(contentsOf: filters)
        
        let url = try urlBuilder.buildURL(
            baseURL: config.baseURL,
            path: config.characterPath,
            queryItems: queryItems
        )
        
        let data = try await httpClient.fetch(url: url)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        do {
            let response = try decoder.decode(CharacterResponse.self, from: data)
            return response.results
        } catch {
            throw NetworkError.decodingError
        }
    }
}
