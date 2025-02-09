//
//  ContentView.swift
//  SearchMyName
//
//  Created by Sanjay Vekariya on 2/6/25.
//

import SwiftUI

struct CharacterSearchHomeView: View {
    @StateObject private var viewModel = CharacterViewModel()
    @State private var isFilterSheetPresented = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                    Section(header: SearchBarView(
                        searchText: $viewModel.searchText,
                        isFilterSheetPresented: $isFilterSheetPresented,
                        onSearchTextChanged: viewModel.searchCharacters,
                        currentFilters: viewModel.filters
                    )) {
                        if viewModel.isLoading {
                            LoadingView()
                        } else if let errorMessage = viewModel.errorMessage {
                            ErrorView(message: errorMessage)
                        } else {
                            CharacterListView(characters: viewModel.characters)
                                .accessibilityIdentifier("character-list")
                        }
                    }
                }
            }
            .navigationTitle("Search My Name")
            .sheet(isPresented: $isFilterSheetPresented) {
                FilterView(
                    currentFilters: viewModel.filters,
                    onApply: viewModel.applyFilters
                )
            }
        }
    }
}

#Preview {
    CharacterSearchHomeView()
}
