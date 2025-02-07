//
//  CharacterListView.swift
//  SearchMyName
//
//  Created by Sanjay Vekariya on 2/7/25.
//

import SwiftUI

struct CharacterListView: View {
    let characters: [Character]
    
    var body: some View {
        ForEach(characters) { character in
            CharacterCardView(character: character)
                .padding(.horizontal)
            Divider()
                .padding(.horizontal)
        }
    }
}

#Preview {
    CharacterListView(characters: [
        .init(id: 1, name: "name1", species: "human", image: "", status: "", type: "", created: "", origin: .init(name: "")),
        .init(id: 2, name: "name2", species: "human", image: "", status: "", type: "", created: "", origin: .init(name: ""))
    ])
}
