//
//  SearchBarView.swift
//  SearchMyName
//
//  Created by Sanjay Vekariya on 2/7/25.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String
    var onSearchTextChanged: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            TextField("Search characters...", text: $searchText)
                .font(.system(size: 18))
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(12)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .onChange(of: searchText) {
                    onSearchTextChanged()
                }
                .autocorrectionDisabled()
            
            Divider()
        }
        .background(Color(UIColor.systemBackground))
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var text = "Sanjay"
        
        var body: some View {
            SearchBarView(searchText: $text) {}
        }
    }
    return PreviewWrapper()
}
