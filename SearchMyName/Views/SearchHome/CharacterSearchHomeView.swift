//
//  ContentView.swift
//  SearchMyName
//
//  Created by Sanjay Vekariya on 2/6/25.
//

import SwiftUI

struct CharacterSearchHomeView: View {
    let namespace: Namespace.ID
    @State private var selectedCharacter: CharacterDetail?
    @State private var isShowingDetail = false
    @State private var isFilterSheetPresented = false
    
    @StateObject private var viewModel = CharacterViewModel()
    
    var body: some View {
        ZStack {
            NavigationStack {
                ScrollView {
                    LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                        searchResultSection()
                    }
                }
                .navigationTitle("Search My Name")
                .sheet(isPresented: $isFilterSheetPresented) {
                    filterView()
                }
            }
            
            if isShowingDetail, let characterInfo = selectedCharacter {
                characterDetailView(characterInfo)
            }
        }
    }
}

private extension CharacterSearchHomeView {
    func searchResultSection() -> some View {
        Section(header: searchBar()) {
            if viewModel.isLoading {
                loadingView()
            } else if let errorMessage = viewModel.errorMessage {
                ErrorView(message: errorMessage)
            } else {
                characterListView()
            }
        }
    }
    
    func loadingView() -> some View {
        ProgressView()
            .padding()
    }
    
    func searchBar() -> SearchBarView {
        SearchBarView(
            searchText: $viewModel.searchText,
            isFilterSheetPresented: $isFilterSheetPresented,
            onSearchTextChanged: viewModel.searchCharacters,
            currentFilters: viewModel.filters
        )
    }
    
    func filterView() -> FilterView {
        FilterView(
            currentFilters: viewModel.filters,
            onApply: viewModel.applyFilters
        )
    }
    
    func characterListView() -> some View {
        CharacterListView(characters: viewModel.characters, namespace: namespace, selectedCharacter: $selectedCharacter, isShowingDetail: $isShowingDetail, onTap: {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                isShowingDetail = true
            }
        })
    }
    
    func characterDetailView(_ characterInfo: CharacterDetail) -> CharacterDetailView {
        CharacterDetailView(
            detail: .init(image: characterInfo.image, character: characterInfo.character),
            namespace: namespace,
            onDismiss: {
                isShowingDetail = false
                selectedCharacter = nil
            }
        )
    }
}

#Preview {
    struct PreviewWrapper: View {
        @Namespace private var namespace
        
        var body: some View {
            CharacterSearchHomeView(namespace: namespace)
        }
    }
    return PreviewWrapper()
}
