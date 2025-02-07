//
//  SharePreviewView.swift
//  SearchMyName
//
//  Created by Sanjay Vekariya on 2/7/25.
//

import SwiftUI

struct SharePreviewView: View {
    let character: Character
    let image: UIImage?
    @Binding var isSharePresented: Bool
    let onShare: () -> Void
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Share Preview")
                        .font(.headline)
                        .padding(.top)
                    
                    if let image = image {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        previewRow(icon: "person.fill", title: "Name", value: character.name)
                        previewRow(icon: "allergens", title: "Species", value: character.species)
                        previewRow(icon: "heart.fill", title: "Status", value: character.status)
                        previewRow(icon: "globe.americas.fill", title: "Origin", value: character.origin.name)
                        
                        if !character.type.isEmpty {
                            previewRow(icon: "tag.fill", title: "Type", value: character.type)
                        }
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal)
                    
                    ShareOptionsView(onShare: onShare)
                        .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        isSharePresented = false
                    }
                }
            }
        }
    }
    
    private func previewRow(icon: String, title: String, value: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.accentColor)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(value)
                    .font(.body)
            }
        }
    }
}
