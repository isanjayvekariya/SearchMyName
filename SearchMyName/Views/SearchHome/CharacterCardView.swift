//
//  CharacterCardView.swift
//  SearchMyName
//
//  Created by Sanjay Vekariya on 2/7/25.
//

import SwiftUI

struct CharacterCardView: View {
    let character: Character
    let namespace: Namespace.ID
    
    @Binding var selectedCharacter: CharacterDetail?
    let onTap: () -> Void
    
    @StateObject private var imageLoader = ImageLoader()
    
    var body: some View {
        HStack(spacing: 16) {
            if let uiImage = imageLoader.image {
                characterAvatar(uiImage)
            } else {
                ProgressView()
            }
            chacterNameAndSpecies()
            Spacer()
        }
        .padding(.vertical, 8)
        .accessibilityIdentifier("character-cell-\(character.id)")
        .task {
            if imageLoader.image == nil {
                await imageLoader.loadImage(from: character.image)
            }
        }
    }
}

private extension CharacterCardView {
    func characterAvatar(_ uiImage: UIImage) -> some View {
        Image(uiImage: uiImage)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 80, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .matchedGeometryEffect(id: "image-\(character.id)", in: namespace, anchor: .center)
            .onTapGesture(perform: {
                selectedCharacter = .init(image: Image(uiImage: uiImage), character: character)
                onTap()
            })
            .accessibilityIdentifier("character-image-\(character.id)")
    }
    
    func chacterNameAndSpecies() -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(character.name)
                .font(.headline)
            Text(character.species)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @Namespace private var namespace
        let character = Character(id: 1, name: "Sanjay", species: "Human", image: "", status: "Alive", type: "", created: "", origin: .init(name: "Earth"))
        
        var body: some View {
            CharacterCardView(character: character, namespace: namespace, selectedCharacter: .constant(.init(image: .init(""), character: character)), onTap: {})
        }
    }
    return PreviewWrapper()
}
