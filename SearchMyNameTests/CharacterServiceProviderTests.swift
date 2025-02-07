//
//  CharacterServiceProviderTests.swift
//  SearchMyName
//
//  Created by Sanjay Vekariya on 2/6/25.
//

import XCTest
@testable import SearchMyName

final class CharacterServiceProviderTests: XCTestCase {
    var sut: CharacterServiceProvider!
    var mockHTTPClient: MockHTTPClient!
    var mockURLBuilder: MockURLBuilder!
    var config: APIConfig!
    
    override func setUp() {
        super.setUp()
        mockHTTPClient = MockHTTPClient()
        mockURLBuilder = MockURLBuilder()
        config = APIConfig(baseURL: "https://test.com", characterPath: "/test")
        sut = CharacterServiceProvider(
            httpClient: mockHTTPClient,
            urlBuilder: mockURLBuilder,
            config: config
        )
    }
    
    override func tearDown() {
        sut = nil
        mockHTTPClient = nil
        mockURLBuilder = nil
        config = nil
        super.tearDown()
    }
    
    func testSearchCharacters_Success() async throws {
        let mockCharacter = Character(
            id: 1,
            name: "Sanjay",
            species: "Human",
            image: "https://example.com/image.jpg",
            status: "Alive",
            type: "",
            created: "2017-11-04T18:48:46.250Z",
            origin: Origin(name: "Earth")
        )
        let mockResponse = CharacterResponse(results: [mockCharacter])
        let mockData = try JSONEncoder().encode(mockResponse)
        mockHTTPClient.result = .success(mockData)
        
        let characters = try await sut.searchCharacters(query: "Sanjay")
        
        XCTAssertEqual(characters.count, 1)
        XCTAssertEqual(characters.first?.name, "Sanjay")
        XCTAssertEqual(mockURLBuilder.capturedBaseURL, config.baseURL)
        XCTAssertEqual(mockURLBuilder.capturedPath, config.characterPath)
        XCTAssertEqual(mockURLBuilder.capturedQueryItems?.first?.name, "name")
        XCTAssertEqual(mockURLBuilder.capturedQueryItems?.first?.value, "Sanjay")
    }
    
    func testSearchCharacters_HTTPError() async {
        mockHTTPClient.result = .failure(NetworkError.httpError(404))
        
        do {
            _ = try await sut.searchCharacters(query: "Sanjay")
            XCTFail("Expected error but got success")
        } catch let error as NetworkError {
            switch error {
            case .httpError(let code):
                XCTAssertEqual(code, 404)
            default:
                XCTFail("Expected HTTP error but got \(error)")
            }
        } catch {
            XCTFail("Expected NetworkError but got \(error)")
        }
    }
    
    func testSearchCharacters_InvalidURL() async {
        mockURLBuilder.shouldFail = true
        
        do {
            _ = try await sut.searchCharacters(query: "Sanjay")
            XCTFail("Expected error but got success")
        } catch NetworkError.invalidURL {
            // Success
        } catch {
            XCTFail("Expected invalidURL error but got \(error)")
        }
    }
}
