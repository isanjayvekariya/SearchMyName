//
//  ErrorView.swift
//  SearchMyName
//
//  Created by Sanjay Vekariya on 2/7/25.
//

import SwiftUI

struct ErrorView: View {
    let message: String
    
    var body: some View {
        VStack {
            Spacer(minLength: 100)
            Image(systemName: "magnifyingglass")
                .font(.system(size: 36))
                .foregroundColor(.gray)
            Text(message)
                .foregroundColor(.gray)
            Spacer()
        }
    }
}

#Preview {
    ErrorView(message: "No characters found")
}
