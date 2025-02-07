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
    
    private var searchTask: Task<Void, Never>?
    private let characterServiceProvider: CharacterServiceProviding
    
    init(characterServiceProvider: CharacterServiceProviding = CharacterServiceProvider()) {
        self.characterServiceProvider = characterServiceProvider
    }
    
    func searchCharacters() {
        searchTask?.cancel()
        
        searchTask = Task {
            // Wait for debounce
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
                characters = try await characterServiceProvider.searchCharacters(query: searchText)
            } catch NetworkError.invalidURL {
                errorMessage = "Invalid search query"
            } catch NetworkError.decodingError {
                errorMessage = "Failed to process data"
            } catch {
                errorMessage = "No characters found"
                characters = []
            }
            
            isLoading = false
        }
    }
}
