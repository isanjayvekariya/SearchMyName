//
//  MockCharacterServiceProvider.swift
//  SearchMyName
//
//  Created by Sanjay Vekariya on 2/7/25.
//

import Foundation
@testable import SearchMyName

class MockCharacterServiceProvider: CharacterServiceProviding {
    var shouldFail = false
    var mockCharacters: [Character] = []
    
    func searchCharacters(query: String) async throws -> [Character] {
        if shouldFail {
            throw NetworkError.noData
        }
        return mockCharacters
    }
}
