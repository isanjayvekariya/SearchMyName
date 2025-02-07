//
//  URLBuilderTests.swift
//  SearchMyName
//
//  Created by Sanjay Vekariya on 2/6/25.
//

import XCTest
@testable import SearchMyName

final class URLBuilderTests: XCTestCase {
    var sut: URLBuilder!
    
    override func setUp() {
        super.setUp()
        sut = URLBuilder()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testBuildURL_WithBasicParameters_CreatesCorrectURL() throws {
        let baseURL = "https://api.example.com"
        let path = "/characters"
        let queryItems = [URLQueryItem(name: "name", value: "sanjay")]
        
        let url = try sut.buildURL(baseURL: baseURL, path: path, queryItems: queryItems)
        
        XCTAssertEqual(url.absoluteString, "https://api.example.com/characters?name=sanjay")
    }
    
    func testBuildURL_WithMultipleQueryParameters_CreatesCorrectURL() throws {
        let baseURL = "https://api.example.com"
        let path = "/characters"
        let queryItems = [
            URLQueryItem(name: "name", value: "sanjay"),
            URLQueryItem(name: "status", value: "alive"),
            URLQueryItem(name: "species", value: "human")
        ]
        
        let url = try sut.buildURL(baseURL: baseURL, path: path, queryItems: queryItems)
        
        XCTAssertEqual(url.absoluteString, "https://api.example.com/characters?name=sanjay&status=alive&species=human")
    }
    
    func testBuildURL_WithSpecialCharacters_EncodesCorrectly() throws {
        let baseURL = "https://api.example.com"
        let path = "/characters"
        let queryItems = [URLQueryItem(name: "name", value: "Sanjay & Vekariya")]
        
        let url = try sut.buildURL(baseURL: baseURL, path: path, queryItems: queryItems)
        
        XCTAssertEqual(url.absoluteString, "https://api.example.com/characters?name=Sanjay%20&%20Vekariya")
    }
    
    func testBuildURL_WithEmptyQueryItems_CreatesURLWithoutQueryParameters() throws {
        let baseURL = "https://api.example.com"
        let path = "/characters"
        let queryItems: [URLQueryItem] = []
        
        let url = try sut.buildURL(baseURL: baseURL, path: path, queryItems: queryItems)
        
        XCTAssertEqual(url.absoluteString, "https://api.example.com/characters?")
    }
    
}
