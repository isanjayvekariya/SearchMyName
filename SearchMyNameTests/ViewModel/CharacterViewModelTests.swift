//
//  CharacterViewModelTests.swift
//  SearchMyName
//
//  Created by Sanjay Vekariya on 2/7/25.
//

import XCTest
@testable import SearchMyName

@MainActor
final class CharacterViewModelTests: XCTestCase {
    func testSuccessfulSearch() async {
        let mockServiceProvider = MockCharacterServiceProvider()
        let mockCharacter = Character(
            id: 1,
            name: "Sanjay",
            species: "Human",
            image: "https://example.com/image.jpg",
            status: "Alive",
            type: "",
            created: "2025-02-07T18:48:46.250Z",
            origin: Origin(name: "Earth")
        )
        mockServiceProvider.mockCharacters = [mockCharacter]
        
        let viewModel = CharacterViewModel(characterServiceProvider: mockServiceProvider)
        
        viewModel.searchText = "Sanjay"
        viewModel.searchCharacters()
        
        // Wait for debounce
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        XCTAssertEqual(viewModel.characters.count, 1)
        XCTAssertEqual(viewModel.characters.first?.name, "Sanjay")
        XCTAssertNil(viewModel.errorMessage)
    }
}
