//
//  CharacterDetailView.swift
//  SearchMyName
//
//  Created by Sanjay Vekariya on 2/7/25.
//

import SwiftUI

struct CharacterDetailView: View {
    let character: Character
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                CharacterImageView(imageURL: character.image)
                    .aspectRatio(contentMode: .fit)
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
