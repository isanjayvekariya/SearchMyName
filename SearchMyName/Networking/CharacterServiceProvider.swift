//
//  CharacterServiceProvider.swift
//  SearchMyName
//
//  Created by Sanjay Vekariya on 2/6/25.
//

import Foundation

protocol CharacterServiceProviding {
    func searchCharacters(query: String) async throws -> [Character]
}

final class CharacterServiceProvider: CharacterServiceProviding {
    private let httpClient: HTTPClient
    private let urlBuilder: URLBuilderProtocol
    private let config: APIConfig
    private let jsonDecoder: JSONDecoder
    
    init(
        httpClient: HTTPClient = URLSessionHTTPClient(),
        urlBuilder: URLBuilderProtocol = URLBuilder(),
        config: APIConfig = .production,
        jsonDecoder: JSONDecoder = JSONDecoder()
    ) {
        self.httpClient = httpClient
        self.urlBuilder = urlBuilder
        self.config = config
        self.jsonDecoder = jsonDecoder
    }
    
    func searchCharacters(query: String) async throws -> [Character] {
        let queryItems = [URLQueryItem(name: "name", value: query)]
        
        let url = try urlBuilder.buildURL(
            baseURL: config.baseURL,
            path: config.characterPath,
            queryItems: queryItems
        )
        
        do {
            let data = try await httpClient.fetch(url: url)
            let response = try jsonDecoder.decode(CharacterResponse.self, from: data)
            return response.results
        } catch let error as NetworkError {
            throw error
        } catch _ as DecodingError {
            throw NetworkError.decodingError
        } catch {
            throw NetworkError.unknown(error)
        }
    }
}
