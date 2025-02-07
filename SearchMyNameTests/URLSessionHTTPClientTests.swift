//
//  URLSessionHTTPClientTests.swift
//  SearchMyName
//
//  Created by Sanjay Vekariya on 2/6/25.
//

import XCTest
@testable import SearchMyName

final class URLSessionHTTPClientTests: XCTestCase {
    var sut: URLSessionHTTPClient!
    var session: MockURLSession!
    
    override func setUp() {
        super.setUp()
        session = MockURLSession()
        sut = URLSessionHTTPClient(session: session)
    }
    
    override func tearDown() {
        sut = nil
        session = nil
        super.tearDown()
    }
    
    func testFetch_WithSuccessfulResponse_ReturnsData() async throws {
        let expectedData = "Test Data".data(using: .utf8)!
        session.data = expectedData
        session.response = HTTPURLResponse(
            url: URL(string: "https://test.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        let resultData = try await sut.fetch(url: URL(string: "https://test.com")!)
        
        XCTAssertEqual(resultData, expectedData)
    }
    
    func testFetch_WithNon200StatusCode_ThrowsError() async {
        session.data = Data()
        session.response = HTTPURLResponse(
            url: URL(string: "https://test.com")!,
            statusCode: 404,
            httpVersion: nil,
            headerFields: nil
        )
        
        do {
            _ = try await sut.fetch(url: URL(string: "https://test.com")!)
            XCTFail("Expected error but got success")
        } catch let error as NetworkError {
            XCTAssertEqual(error, NetworkError.httpError(404))
        } catch {
            XCTFail("Expected NetworkError but got \(error)")
        }
    }
    
    func testFetch_WithNetworkError_ThrowsError() async {
        struct TestError: Error {}
        session.error = TestError()
        
        do {
            _ = try await sut.fetch(url: URL(string: "https://test.com")!)
            XCTFail("Expected error but got success")
        } catch is TestError {
            // Success
        } catch {
            XCTFail("Expected TestError but got \(error)")
        }
    }
    
    func testFetch_WithNonHTTPResponse_ThrowsError() async {
        session.data = Data()
        session.response = URLResponse(
            url: URL(string: "https://test.com")!,
            mimeType: nil,
            expectedContentLength: 0,
            textEncodingName: nil
        )
        
        do {
            _ = try await sut.fetch(url: URL(string: "https://test.com")!)
            XCTFail("Expected error but got success")
        } catch let error as NetworkError {
            XCTAssertEqual(error, NetworkError.noData)
        } catch {
            XCTFail("Expected NetworkError but got \(error)")
        }
    }
    
    func testFetch_WithDifferentStatusCodes() async throws {
        let statusCodesToTest = [200, 201, 299, 300, 400, 404, 500]
        
        for statusCode in statusCodesToTest {
            session.data = Data()
            session.response = HTTPURLResponse(
                url: URL(string: "https://test.com")!,
                statusCode: statusCode,
                httpVersion: nil,
                headerFields: nil
            )
            
            do {
                _ = try await sut.fetch(url: URL(string: "https://test.com")!)
                // Should succeed for 2xx status codes
                XCTAssertTrue((200...299).contains(statusCode), "Expected success only for 2xx status codes")
            } catch let error as NetworkError {
                // Should fail for non-2xx status codes
                XCTAssertFalse((200...299).contains(statusCode), "Expected failure for non-2xx status codes")
                if case .httpError(let code) = error {
                    XCTAssertEqual(code, statusCode)
                }
            } catch {
                XCTFail("Unexpected error type: \(error)")
            }
        }
    }
    
    func testFetch_WithLargeData() async throws {
        let largeData = Data(repeating: 0, count: 1_000_000) // 1MB of data
        session.data = largeData
        session.response = HTTPURLResponse(
            url: URL(string: "https://test.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        let resultData = try await sut.fetch(url: URL(string: "https://test.com")!)
        
        XCTAssertEqual(resultData.count, largeData.count)
    }
    
    func testFetch_WithEmptyData() async throws {
        
        let emptyData = Data()
        session.data = emptyData
        session.response = HTTPURLResponse(
            url: URL(string: "https://test.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        let resultData = try await sut.fetch(url: URL(string: "https://test.com")!)
        
        XCTAssertEqual(resultData.count, 0)
    }
}
