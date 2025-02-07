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
    var sut: CharacterViewModel!
    var mockService: MockCharacterServiceProvider!
    
    override func setUp() {
        super.setUp()
        mockService = MockCharacterServiceProvider()
        sut = CharacterViewModel(characterService: mockService)
    }
    
    override func tearDown() {
        sut = nil
        mockService = nil
        super.tearDown()
    }
    
    func testSearchCharacters_WhenSuccessful_UpdatesCharacters() async {
        let expectedCharacter = Character.mockCharacter()
        mockService.mockCharacters = [expectedCharacter]
        
        sut.searchText = "Sanjay"
        sut.searchCharacters()
        
        // Wait for debounce
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        XCTAssertEqual(sut.characters.count, 1)
        XCTAssertEqual(sut.characters.first?.id, expectedCharacter.id)
        XCTAssertNil(sut.errorMessage)
        XCTAssertFalse(sut.isLoading)
    }
    
    func testSearchCharacters_WhenEmptyQuery_ClearsResults() async {
        mockService.mockCharacters = [.mockCharacter()]
        
        sut.searchText = ""
        sut.searchCharacters()
        
        // Wait for debounce
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        XCTAssertTrue(sut.characters.isEmpty)
        XCTAssertNil(sut.errorMessage)
        XCTAssertFalse(sut.isLoading)
    }
    
    func testSearchCharacters_WhenError_ShowsErrorMessage() async {
        mockService.shouldFail = true
        mockService.error = NetworkError.noData
        
        sut.searchText = "Sanjay"
        sut.searchCharacters()
        
        // Wait for debounce
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        XCTAssertTrue(sut.characters.isEmpty)
        XCTAssertNotNil(sut.errorMessage)
        XCTAssertFalse(sut.isLoading)
    }
    
    func testApplyFilters_UpdatesSearchResults() async {
        let expectedCharacter = Character.mockCharacter()
        mockService.mockCharacters = [expectedCharacter]
        let filters = CharacterFilters(status: "Alive", species: "Human")
        
        sut.searchText = "Sanjay"
        sut.applyFilters(filters)
        
        // Wait for debounce
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        XCTAssertEqual(sut.filters.status, "Alive")
        XCTAssertEqual(sut.filters.species, "Human")
        XCTAssertEqual(sut.characters.count, 1)
    }
}
