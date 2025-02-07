//
//  MockCharacterServiceProvider.swift
//  SearchMyName
//
//  Created by Sanjay Vekariya on 2/7/25.
//

import Foundation
@testable import SearchMyName

class MockCharacterServiceProvider: CharacterServiceProviding {
    var mockCharacters: [Character] = []
    var shouldFail = false
    var error: NetworkError = .noData
    
    // Capture API call parameters for verification in tests
    private(set) var lastSearchQuery: String?
    private(set) var lastSearchFilters: [URLQueryItem]?
    
    func searchCharacters(query: String, filters: [URLQueryItem] = []) async throws -> [Character] {
        // Capture the parameters
        lastSearchQuery = query
        lastSearchFilters = filters
        
        // Simulate network failure if needed
        if shouldFail {
            throw error
        }
        
        // Apply filters to mock data
        return mockCharacters.filter { character in
            let matchesQuery = character.name.lowercased().contains(query.lowercased())
            
            let matchesFilters = filters.allSatisfy { filter in
                switch filter.name {
                case "status":
                    return character.status.lowercased() == filter.value?.lowercased()
                case "species":
                    return character.species.lowercased() == filter.value?.lowercased()
                case "type":
                    guard let filterValue = filter.value else { return true }
                    return character.type.lowercased().contains(filterValue.lowercased())
                default:
                    return true
                }
            }
            
            return matchesQuery && matchesFilters
        }
    }
    
    // Helper method to reset the mock service state
    func reset() {
        mockCharacters = []
        shouldFail = false
        error = .noData
        lastSearchQuery = nil
        lastSearchFilters = nil
    }
}
