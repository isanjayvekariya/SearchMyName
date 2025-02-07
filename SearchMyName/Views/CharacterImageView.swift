//
//  CharacterImageView.swift
//  SearchMyName
//
//  Created by Sanjay Vekariya on 2/7/25.
//

import SwiftUI

struct CharacterImageView: View {
    let imageURL: String
    
    var body: some View {
        AsyncImage(url: URL(string: imageURL)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
        } placeholder: {
            ProgressView()
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    CharacterImageView(imageURL: "www.aetna.com")
}
