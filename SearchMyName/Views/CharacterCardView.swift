//
//  CharacterCardView.swift
//  SearchMyName
//
//  Created by Sanjay Vekariya on 2/7/25.
//

import SwiftUI

struct CharacterCardView: View {
    let character: Character
    
    var body: some View {
        HStack(spacing: 16) {
            NavigationLink(destination: Text("Details")) {
                AsyncImage(url: URL(string: character.image)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 8))
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
    }
}

#Preview {
    CharacterCardView(character: .init(id: 1, name: "Sanjay", species: "Human", image: "", status: "", type: "", created: "", origin: .init(name: "USA")))
}
