//
//  CharacterDetailView.swift
//  SearchMyName
//
//  Created by Sanjay Vekariya on 2/7/25.
//

import SwiftUI

struct CharacterDetail {
    let image: Image
    let character: Character
}

struct CharacterDetailView: View {
    let detail: CharacterDetail
    let namespace: Namespace.ID
    let onDismiss: () -> Void
    
    @State private var isSharePresented: Bool = false
    @State private var isShowingShareSheet: Bool = false
    
    @StateObject private var imageLoader = ImageLoader()
    
    var body: some View {
        Color(UIColor.systemBackground)
            .ignoresSafeArea()
            .overlay {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        headerView()
                        characterImage()
                        characterDetails()
                    }
                }
            }
            .accessibilityIdentifier("character-detail-view")
            .sheet(isPresented: $isSharePresented) {
                SharePreviewView(
                    detail: detail,
                    isSharePresented: $isSharePresented,
                    onShare: {
                        isSharePresented = false
                        isShowingShareSheet = true
                    }
                )
            }
            .sheet(isPresented: $isShowingShareSheet) {
                shareSheet
            }
    }
}

private extension CharacterDetailView {
    // Title, Share Icon and Close button
    func headerView() -> some View {
        HStack {
            titleText()
            
            Spacer()
            
            HStack {
                shareIcon()
                closeButton()
            }
            .padding(.trailing)
        }
    }
    
    func titleText() -> some View {
        Text(detail.character.name)
            .font(.title2)
            .bold()
            .padding(.leading)
            .accessibilityIdentifier("character-detail-title")
    }
    
    func shareIcon() -> some View {
        Button(action: {
            isSharePresented = true
        }) {
            Image(systemName: "square.and.arrow.up")
                .font(.title2)
        }
    }
    
    func closeButton() -> some View {
        Button(action: {
            onDismiss()
        }) {
            Image(systemName: "xmark.circle.fill")
                .font(.title)
                .foregroundColor(.gray)
        }
        .accessibilityIdentifier("close-button")
    }
    
    func characterImage() -> some View {
        detail.image
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: .infinity)
            .matchedGeometryEffect(id: "image-\(detail.character.id)", in: namespace, anchor: .center)
            .accessibilityIdentifier("character-detail-image")
    }
    
    func characterDetails() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            detailRow(title: "Species", value: detail.character.species)
            detailRow(title: "Status", value: detail.character.status)
            detailRow(title: "Origin", value: detail.character.origin.name)
            
            if !detail.character.type.isEmpty {
                detailRow(title: "Type", value: detail.character.type)
            }
            
            detailRow(title: "Created", value: detail.character.formattedCreatedDate)
        }
        .padding()
    }
    
    func detailRow(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)
            Text(value)
                .font(.body)
        }
    }
    
    var shareSheet: some View {
        let metadata = """
        Character: \(detail.character.name)
        Species: \(detail.character.species)
        Status: \(detail.character.status)
        Origin: \(detail.character.origin.name)
        \(detail.character.type.isEmpty ? "" : "Type: \(detail.character.type)\n")
        Created: \(detail.character.formattedCreatedDate)
        """
        
        return ShareView(activityItems: [detail.image as Any, metadata].compactMap { $0 })
    }
}

#Preview {
    struct PreviewWrapper: View {
        @Namespace private var namespace
        let character = Character(id: 1, name: "Sanjay Sanjay Sanjay", species: "Human", image: "", status: "Alive", type: "", created: "", origin: .init(name: "Earth"))
        
        var body: some View {
            CharacterDetailView(detail: .init(image: .init(""), character: character), namespace: namespace, onDismiss: {})
        }
    }
    return PreviewWrapper()
}
