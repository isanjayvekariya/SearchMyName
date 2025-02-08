//
//  FilterViewUITests.swift
//  SearchMyName
//
//  Created by Sanjay Vekariya on 2/8/25.
//

import XCTest

final class FilterViewUITests: XCTestCase {
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    // Validates tapping filter button Navigates to FilterView
    func testFilterViewNavigation() throws {
        XCTAssertTrue(filterButton.waitForExistence(timeout: 5))
        
        filterButton.tap()
        
        validatePickersExist()
        XCTAssertTrue(typeField.waitForExistence(timeout: 5))
    }
    
    // Validates selected filters applies and Navigates to previous screen
    func testFilterSelection() throws {
        XCTAssertTrue(filterButton.waitForExistence(timeout: 5))
        filterButton.tap()
        
        // Select status picker
        XCTAssertTrue(statusPicker.waitForExistence(timeout: 5))
        statusPicker.tap()
        
        // Select "Alive" from status menu
        let aliveButton = app.buttons["Alive"]
        XCTAssertTrue(aliveButton.waitForExistence(timeout: 5))
        aliveButton.tap()
        
        // Select species picker
        XCTAssertTrue(speciesPicker.waitForExistence(timeout: 5))
        speciesPicker.tap()
        
        // Select "Human" from species menu
        let humanButton = app.buttons["Human"]
        XCTAssertTrue(humanButton.waitForExistence(timeout: 5))
        humanButton.tap()
        
        // Type some text
        XCTAssertTrue(typeField.waitForExistence(timeout: 5))
        typeField.tap()
        typeField.typeText("Test")
        
        // Apply filters
        XCTAssertTrue(applyFiltersButton.waitForExistence(timeout: 5))
        applyFiltersButton.tap()
        
        // Verify we're back to the main view
        XCTAssertTrue(searchField.waitForExistence(timeout: 5))
    }
    
    // Validates resetting filters does set to picker to original state
    func testFilterReset() throws {
        XCTAssertTrue(filterButton.waitForExistence(timeout: 5))
        filterButton.tap()
        
        XCTAssertTrue(resetFiltersButton.waitForExistence(timeout: 5))
        resetFiltersButton.tap()
        
        validatePickersExist()
        XCTAssertTrue(typeField.waitForExistence(timeout: 5))
        
        // Verify the status text shows "Any"
        let anyText = app.staticTexts["Any"]
        XCTAssertTrue(anyText.exists)
    }
    
    // Validates tapping cancel dismiss the FilterView and Navigates back
    func testFilterCancellation() throws {
        XCTAssertTrue(filterButton.waitForExistence(timeout: 5))
        filterButton.tap()
        
        XCTAssertTrue(cancelButton.waitForExistence(timeout: 5))
        cancelButton.tap()
        
        // Verify we're back to the main view
        XCTAssertTrue(searchField.waitForExistence(timeout: 5))
    }
    
    private func validatePickersExist() {
        XCTAssertTrue(statusPicker.waitForExistence(timeout: 5))
        XCTAssertTrue(speciesPicker.waitForExistence(timeout: 5))
    }
}

private extension FilterViewUITests {
    var statusPicker: XCUIElement {
        app.collectionViews.buttons["status-picker"].staticTexts["Any"]
    }
    
    var speciesPicker: XCUIElement {
        app.collectionViews.buttons["species-picker"].staticTexts["Any"]
    }
    
    var typeField: XCUIElement {
        app.collectionViews.textFields["type-field"]
    }
    
    var resetFiltersButton: XCUIElement {
        app.collectionViews.buttons["reset-filters-button"]
    }
    
    var applyFiltersButton: XCUIElement {
        app.navigationBars["Filters"].firstMatch.buttons["apply-filters-button"]
    }
    
    var cancelButton: XCUIElement {
        app.navigationBars["Filters"].buttons["cancel-button"]
    }
}

