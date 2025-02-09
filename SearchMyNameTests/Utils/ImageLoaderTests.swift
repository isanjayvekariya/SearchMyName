//
//  ImageLoaderTests.swift
//  SearchMyName
//
//  Created by Sanjay Vekariya on 2/8/25.
//

@testable import SearchMyName
import XCTest

@MainActor
final class ImageLoaderTests: XCTestCase {
    private var sut: ImageLoader!
    private var mockURLSession: MockURLSession!
    
    override func setUp() {
        super.setUp()
        mockURLSession = MockURLSession()
        sut = ImageLoader(session: mockURLSession)
    }
    
    override func tearDown() {
        sut = nil
        mockURLSession = nil
        super.tearDown()
    }
    
    func testLoadImage_WhenSuccessful_SetsImage() async {
        let imageData = UIImage(systemName: "person")?.pngData()
        mockURLSession.data = imageData
        
        await sut.loadImage(from: "https://example.com/image.png")
        
        XCTAssertNotNil(sut.image)
    }
    
    func testLoadImage_WhenInvalidURL_DoesNotSetImage() async {
        let invalidURL = ""
        
        await sut.loadImage(from: invalidURL)
        
        XCTAssertNil(sut.image)
    }
    
    func testLoadImage_WhenNetworkError_DoesNotSetImage() async {
        mockURLSession.error = NSError(domain: "test", code: -1)
        
        await sut.loadImage(from: "https://example.com/image.png")
        
        XCTAssertNil(sut.image)
    }
    
    func testLoadImage_WhenInvalidImageData_DoesNotSetImage() async {
        mockURLSession.data = "invalid image data".data(using: .utf8)
        
        await sut.loadImage(from: "https://example.com/image.png")
        
        XCTAssertNil(sut.image)
    }
    
    func testLoadImage_CapturesCorrectURL() async {
        let imageURL = "https://example.com/image.png"
        
        await sut.loadImage(from: imageURL)
        
        XCTAssertEqual(mockURLSession.lastURL?.absoluteString, imageURL)
    }
    
    func testLoadImage_MultipleCalls_OnlyKeepsLastImage() async {
        let firstImage = UIImage(systemName: "person")?.pngData()
        let secondImage = UIImage(systemName: "star")?.pngData()
        
        mockURLSession.data = firstImage
        await sut.loadImage(from: "https://example.com/first.png")
        let firstLoadedImage = sut.image
        
        mockURLSession.data = secondImage
        await sut.loadImage(from: "https://example.com/second.png")
        
        XCTAssertNotEqual(sut.image, firstLoadedImage)
    }
}
