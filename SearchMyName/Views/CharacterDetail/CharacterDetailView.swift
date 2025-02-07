//
//  CharacterDetailView.swift
//  SearchMyName
//
//  Created by Sanjay Vekariya on 2/7/25.
//

import SwiftUI

struct CharacterDetailView: View {
    let character: Character
    @State private var isSharePresented: Bool = false
    @State private var imageToShare: UIImage?
    @State private var isShowingShareSheet: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                AsyncImage(url: URL(string: character.image)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .onAppear {
                            if let uiImage = image.asUIImage() {
                                imageToShare = uiImage
                            }
                        }
                } placeholder: {
                    ProgressView()
                }
                .frame(maxWidth: .infinity)
                
                VStack(alignment: .leading, spacing: 12) {
                    detailRow(title: "Species", value: character.species)
                    detailRow(title: "Status", value: character.status)
                    detailRow(title: "Origin", value: character.origin.name)
                    
                    if !character.type.isEmpty {
                        detailRow(title: "Type", value: character.type)
                    }
                    
                    detailRow(title: "Created", value: character.formattedCreatedDate)
                }
                .padding()
            }
        }
        .navigationTitle(character.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    isSharePresented = true
                }) {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
        .sheet(isPresented: $isSharePresented) {
            SharePreviewView(
                character: character,
                image: imageToShare,
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
    
    private var shareSheet: some View {
        let metadata = """
        Character: \(character.name)
        Species: \(character.species)
        Status: \(character.status)
        Origin: \(character.origin.name)
        \(character.type.isEmpty ? "" : "Type: \(character.type)\n")
        Created: \(character.formattedCreatedDate)
        """
        
        return ShareView(activityItems: [imageToShare as Any, metadata].compactMap { $0 })
    }
    
    private func detailRow(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)
            Text(value)
                .font(.body)
        }
    }
}
