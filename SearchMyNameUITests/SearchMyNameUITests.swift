//
//  SearchMyNameUITests.swift
//  SearchMyNameUITests
//
//  Created by Sanjay Vekariya on 2/6/25.
//

import XCTest

final class SearchMyNameUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    func testSearchFlow() throws {
        let searchField = app.textFields["search-field"]
        
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
    
    func testFilterButtonExists() throws {
        // Test for filter button existence
        let filterButton = app.buttons["filter-button"]
        XCTAssertTrue(filterButton.waitForExistence(timeout: 5))
    }
    
    func testDetailViewNavigation() throws {
        let searchField = app.textFields["search-field"]
        XCTAssertTrue(searchField.waitForExistence(timeout: 5))
        
        searchField.tap()
        searchField.typeText("Rick")
        
        // Wait for results and tap first cell
        sleep(2) // Wait for network request
        
        // Verify the first character image exists
        XCTAssertTrue(firstCharImage.waitForExistence(timeout: 5))
        // Tap on the image to navigate to details
        firstCharImage.tap()
        
        // Then - verify we're on the detail view
        XCTAssertTrue(charDetailView.waitForExistence(timeout: 5))
    }
}

extension SearchMyNameUITests {
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
