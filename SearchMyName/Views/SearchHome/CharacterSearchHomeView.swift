//
//  ContentView.swift
//  SearchMyName
//
//  Created by Sanjay Vekariya on 2/6/25.
//

import SwiftUI

struct CharacterSearchHomeView: View {
    @StateObject private var viewModel = CharacterViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                    Section(header: SearchBarView(
                        searchText: $viewModel.searchText,
                        onSearchTextChanged: viewModel.searchCharacters
                    )) {
                        Group {
                            if viewModel.isLoading {
                                LoadingView()
                            } else if let errorMessage = viewModel.errorMessage {
                                ErrorView(message: errorMessage)
                            } else {
                                CharacterListView(characters: viewModel.characters)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Search My Name")
        }
    }
}

#Preview {
    CharacterSearchHomeView()
}
