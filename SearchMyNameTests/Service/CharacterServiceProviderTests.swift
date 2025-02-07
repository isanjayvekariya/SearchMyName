//
//  CharacterServiceProviderTests.swift
//  SearchMyName
//
//  Created by Sanjay Vekariya on 2/6/25.
//

import XCTest
@testable import SearchMyName

final class CharacterServiceTests: XCTestCase {
    var sut: CharacterServiceProvider!
    var mockHTTPClient: MockHTTPClient!
    var mockURLBuilder: MockURLBuilder!
    
    override func setUp() {
        super.setUp()
        mockHTTPClient = MockHTTPClient()
        mockURLBuilder = MockURLBuilder()
        sut = CharacterServiceProvider(
            httpClient: mockHTTPClient,
            urlBuilder: mockURLBuilder
        )
    }
    
    override func tearDown() {
        sut = nil
        mockHTTPClient = nil
        mockURLBuilder = nil
        super.tearDown()
    }
    
    func testSearchCharacters_Success() async throws {
        let mockCharacter = Character.mockCharacter()
        let mockResponse = CharacterResponse(results: [mockCharacter])
        let mockData = try JSONEncoder().encode(mockResponse)
        mockHTTPClient.mockData = mockData
        mockURLBuilder.mockURL = URL(string: "https://test.com")!
        
        let characters = try await sut.searchCharacters(query: "Sanjay", filters: [])
        
        XCTAssertEqual(characters.count, 1)
        XCTAssertEqual(characters.first?.id, mockCharacter.id)
    }
    
    func testSearchCharacters_WithFilters_BuildsCorrectURL() async throws {
        let filters = [
            URLQueryItem(name: "status", value: "Alive"),
            URLQueryItem(name: "species", value: "Human")
        ]
        
        _ = try? await sut.searchCharacters(query: "Sanjay", filters: filters)
        
        let capturedQueryItems = mockURLBuilder.capturedQueryItems ?? []
        XCTAssertEqual(capturedQueryItems.count, 3) // name query + 2 filters
        XCTAssertTrue(capturedQueryItems.contains(where: { $0.name == "name" && $0.value == "Sanjay" }))
        XCTAssertTrue(capturedQueryItems.contains(where: { $0.name == "status" && $0.value == "Alive" }))
        XCTAssertTrue(capturedQueryItems.contains(where: { $0.name == "species" && $0.value == "Human" }))
    }
    
    func testSearchCharacters_HTTPError_ThrowsError() async {
        mockHTTPClient.mockError = NetworkError.httpError(404)
        
        do {
            _ = try await sut.searchCharacters(query: "Sanjay", filters: [])
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is NetworkError)
        }
    }
    
    func testSearchCharacters_InvalidJSON_ThrowsDecodingError() async {
        mockHTTPClient.mockData = "Invalid JSON".data(using: .utf8)
        
        do {
            _ = try await sut.searchCharacters(query: "Sanjay", filters: [])
            XCTFail("Expected error to be thrown")
        } catch NetworkError.decodingError {
            // Success
        } catch {
            XCTFail("Expected NetworkError.decodingError but got \(error)")
        }
    }
}
