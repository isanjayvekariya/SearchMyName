//
//  CharacterCardView.swift
//  SearchMyName
//
//  Created by Sanjay Vekariya on 2/7/25.
//

import SwiftUI

struct CharacterCardView: View {
    let character: Character
    
    @StateObject private var imageLoader = ImageLoader()
    
    var body: some View {
        HStack(spacing: 16) {
            NavigationLink(destination: CharacterDetailView(character: character)) {
                if let uiImage = imageLoader.image {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 80, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .accessibilityIdentifier("character-cell-image-\(character.id)")
                } else {
                    ProgressView()
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(character.name)
                    .font(.headline)
                Text(character.species)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
        .task {
            await imageLoader.loadImage(from: character.image)
        }
    }
}

#Preview {
    CharacterCardView(character: .init(id: 1, name: "Sanjay", species: "Human", image: "", status: "", type: "", created: "", origin: .init(name: "USA")))
}
