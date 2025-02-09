//
//  SharePreviewView.swift
//  SearchMyName
//
//  Created by Sanjay Vekariya on 2/7/25.
//

import SwiftUI

struct SharePreviewView: View {
    let detail: CharacterDetail
    @Binding var isSharePresented: Bool
    let onShare: () -> Void
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Share Preview")
                        .font(.headline)
                        .padding(.top)
                    
                    previewImage()
                    previewDetails()
                    
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
}

private extension SharePreviewView {
    func previewImage() -> some View {
        detail.image
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    func previewDetails() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            previewRow(icon: "person.fill", title: "Name", value: detail.character.name)
            previewRow(icon: "allergens", title: "Species", value: detail.character.species)
            previewRow(icon: "heart.fill", title: "Status", value: detail.character.status)
            previewRow(icon: "globe.americas.fill", title: "Origin", value: detail.character.origin.name)
            
            if !detail.character.type.isEmpty {
                previewRow(icon: "tag.fill", title: "Type", value: detail.character.type)
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal)
    }
    
    func previewRow(icon: String, title: String, value: String) -> some View {
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

#Preview {
    struct PreviewWrapper: View {
        let character = Character(id: 1, name: "Sanjay", species: "Human", image: "", status: "Alive", type: "", created: "", origin: .init(name: "Earth"))
        
        var body: some View {
            SharePreviewView(detail: .init(image: .init(systemName: "human.fill"), character: character), isSharePresented: .constant(true), onShare: {})
        }
    }
    return PreviewWrapper()
}
