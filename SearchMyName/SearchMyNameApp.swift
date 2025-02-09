//
//  SearchMyNameApp.swift
//  SearchMyName
//
//  Created by Sanjay Vekariya on 2/6/25.
//

import SwiftUI

@main
struct SearchMyNameApp: App {
    @Namespace private var namespace
    
    var body: some Scene {
        WindowGroup {
            CharacterSearchHomeView(namespace: namespace)
        }
    }
}
