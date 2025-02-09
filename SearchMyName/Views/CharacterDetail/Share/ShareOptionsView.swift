//
//  ShareOptionsView.swift
//  SearchMyName
//
//  Created by Sanjay Vekariya on 2/7/25.
//

import SwiftUI

struct ShareOptionsView: View {
    let onShare: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Share Options")
                .font(.headline)
            shareOptionGroup()
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

private extension ShareOptionsView {
    func shareOptionGroup() -> HStack<TupleView<(some View, some View, some View)>> {
        HStack(spacing: 20) {
            shareButton(icon: "square.and.arrow.up", title: "Share", action: onShare)
            shareButton(icon: "square.and.arrow.down", title: "Save", action: onShare)
            shareButton(icon: "doc.on.doc", title: "Copy", action: onShare)
        }
    }
    
    func shareButton(icon: String, title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                Text(title)
                    .font(.caption)
            }
            .frame(minWidth: 80)
            .padding()
            .background(Color(UIColor.tertiarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}


#Preview {
    ShareOptionsView(onShare: {})
}
