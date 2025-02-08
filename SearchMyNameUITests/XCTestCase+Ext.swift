//
//  XCTestCase+Ext.swift
//  SearchMyName
//
//  Created by Sanjay Vekariya on 2/8/25.
//

import XCTest

// MARK: - Common Use
extension XCTestCase {
    var app: XCUIApplication {
        XCUIApplication()
    }

    var searchField: XCUIElement {
        app.textFields["search-field"]
    }
    
    var filterButton: XCUIElement {
        app.buttons["Filter"]
    }
}
