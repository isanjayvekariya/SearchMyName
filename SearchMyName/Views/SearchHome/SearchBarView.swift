//
//  SearchBarView.swift
//  SearchMyName
//
//  Created by Sanjay Vekariya on 2/7/25.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String
    @Binding var isFilterSheetPresented: Bool
    let onSearchTextChanged: () -> Void
    let currentFilters: CharacterFilters
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                TextField("Search characters...", text: $searchText)
                    .font(.system(size: 18))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(12)
                    .onChange(of: searchText) {
                        onSearchTextChanged()
                    }
                    .autocorrectionDisabled()
                    .accessibilityIdentifier("search-field")
                
                Button(action: {
                    isFilterSheetPresented = true
                }) {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .font(.title2)
                        .foregroundColor(.accentColor)
                        .overlay(
                            Group {
                                if currentFilters.hasActiveFilters {
                                    Circle()
                                        .fill(.red)
                                        .frame(width: 8, height: 8)
                                        .offset(x: 10, y: -10)
                                        .accessibilityIdentifier("FilterIndicator")
                                }
                            }
                        )
                }
                .accessibilityIdentifier("filter-button")
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            
            Divider()
        }
        .background(Color(UIColor.systemBackground))
    }
}

#Preview {
    struct PreviewWrapper: View {
        var body: some View {
            VStack {
                SearchBarView(
                    searchText: .constant("Sanjay"),
                    isFilterSheetPresented: .constant(false),
                    onSearchTextChanged: {},
                    currentFilters: CharacterFilters(status: "Alive", species: "Human")
                )
            }
        }
    }
    return PreviewWrapper()
}
