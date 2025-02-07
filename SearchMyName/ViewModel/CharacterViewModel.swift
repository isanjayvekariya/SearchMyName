//
//  CharacterViewModel.swift
//  SearchMyName
//
//  Created by Sanjay Vekariya on 2/7/25.
//

import SwiftUI

@MainActor
class CharacterViewModel: ObservableObject {
    @Published var characters: [Character] = []
    @Published var searchText = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var filters = CharacterFilters()
    
    private var searchTask: Task<Void, Never>?
    private let characterService: CharacterServiceProviding
    
    init(characterService: CharacterServiceProviding = CharacterServiceProvider()) {
        self.characterService = characterService
    }
    
    var filterQueryItems: [URLQueryItem] {
        var items: [URLQueryItem] = []
        
        if !filters.status.isEmpty {
            items.append(URLQueryItem(name: "status", value: filters.status))
        }
        if !filters.species.isEmpty {
            items.append(URLQueryItem(name: "species", value: filters.species))
        }
        if !filters.type.isEmpty {
            items.append(URLQueryItem(name: "type", value: filters.type))
        }
        
        return items
    }
    
    func searchCharacters() {
        searchTask?.cancel()
        
        searchTask = Task {
            // wait for debounce
            try? await Task.sleep(nanoseconds: 500_000_000)
            
            guard !Task.isCancelled else { return }
            
            guard !searchText.isEmpty else {
                characters = []
                errorMessage = nil
                return
            }
            
            isLoading = true
            errorMessage = nil
            
            do {
                characters = try await characterService.searchCharacters(
                    query: searchText,
                    filters: filterQueryItems
                )
                errorMessage = characters.isEmpty ? "No characters found" : nil
            } catch NetworkError.invalidURL {
                errorMessage = "Invalid search query"
            } catch NetworkError.decodingError {
                errorMessage = "Failed to process data"
            } catch NetworkError.httpError {
                errorMessage = "No characters found"
            } catch {
                errorMessage = "Something went wrong"
                characters = []
            }
            
            isLoading = false
        }
    }
    
    func applyFilters(_ newFilters: CharacterFilters) {
        filters = newFilters
        searchCharacters()
    }
}
