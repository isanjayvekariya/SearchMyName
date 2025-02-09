//
//  CharacterListView.swift
//  SearchMyName
//
//  Created by Sanjay Vekariya on 2/7/25.
//

import SwiftUI

struct CharacterListView: View {
    let characters: [Character]
    let namespace: Namespace.ID
    
    @Binding var selectedCharacter: CharacterDetail?
    @Binding var isShowingDetail: Bool
    
    let onTap: () -> Void
    
    var body: some View {
        ForEach(characters) { character in
            characterCardView(character)
            Divider()
                .padding(.horizontal)
        }
        .accessibilityIdentifier("character-list")
    }
    
    private func characterCardView(_ character: Character) -> some View {
        CharacterCardView(
            character: character,
            namespace: namespace,
            selectedCharacter: $selectedCharacter,
            onTap: onTap
        )
        .padding(.horizontal)
        .accessibilityIdentifier("character-list-\(character.id)")
    }
}

#Preview {
    struct PreviewWrapper: View {
        @Namespace private var namespace
        let character = Character(id: 1, name: "Sanjay", species: "Human", image: "", status: "Alive", type: "", created: "", origin: .init(name: "Earth"))
        
        var body: some View {
            CharacterListView(characters: [
                character, character
            ], namespace: namespace, selectedCharacter: .constant(.init(image: .init(""), character: character)), isShowingDetail: .constant(false), onTap: {})
        }
    }
    return PreviewWrapper()
}
