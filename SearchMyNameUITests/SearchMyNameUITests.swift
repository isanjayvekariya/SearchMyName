//
//  SearchMyNameUITests.swift
//  SearchMyNameUITests
//
//  Created by Sanjay Vekariya on 2/6/25.
//

import XCTest

final class SearchMyNameUITests: XCTestCase {
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    // Validates able to search and loads a result into a list
    func testSearchCharacterFlow() throws {
        // Wait for the search field to appear
        XCTAssertTrue(searchField.waitForExistence(timeout: 5))
        
        searchField.tap()
        searchField.typeText("Rick")
        
        // Wait for results to load
        let predicate = NSPredicate(format: "exists == true")
        let characterList = app.otherElements["character-list"]
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: characterList)
        
        let result = XCTWaiter().wait(for: [expectation], timeout: 10)
        XCTAssertEqual(result, .completed)
    }
    
    // Validates tapping on character image Nvigates to details
    func testDetailViewNavigation() throws {
        XCTAssertTrue(searchField.waitForExistence(timeout: 5))
        
        searchField.tap()
        searchField.typeText("Rick")
        
        // Wait for results and tap first cell
        sleep(2) // Wait for network request
        
        // Verify the first character image exists
        XCTAssertTrue(firstCharImage.waitForExistence(timeout: 5))
        // Tap on the image to navigate to details
        firstCharImage.tap()
        
        // Verify we're on the detail view
        XCTAssertTrue(charDetailView.waitForExistence(timeout: 5))
    }
}

private extension SearchMyNameUITests {
    var scrollView: XCUIElementQuery {
        app.scrollViews
    }
    
    var firstCharImage: XCUIElement {
        scrollView.otherElements.buttons.containing(.image, identifier:"character-cell-image-1").element
    }
    
    var charDetailView: XCUIElement {
        scrollView["character-detail-view"]
    }
}
