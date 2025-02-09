//
//  FilterView.swift
//  SearchMyName
//
//  Created by Sanjay Vekariya on 2/7/25.
//

import SwiftUI

struct FilterView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var filters: CharacterFilters
    let onApply: (CharacterFilters) -> Void
    
    init(currentFilters: CharacterFilters, onApply: @escaping (CharacterFilters) -> Void) {
        _filters = State(initialValue: currentFilters)
        self.onApply = onApply
    }
    
    var body: some View {
        NavigationStack {
            Form {
                statusSection()
                speciesSection()
                typeSection()
                resetFilterSection()
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .accessibilityIdentifier("cancel-button")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Apply") {
                        onApply(filters)
                        dismiss()
                    }
                    .accessibilityIdentifier("apply-filters-button")
                }
            }
        }
        .accessibilityIdentifier("filters-view")
    }
}

private extension FilterView {
    func statusSection() -> some View {
        Section("Status") {
            Picker("Status", selection: $filters.status) {
                ForEach(CharacterFilters.statusOptions, id: \.self) { status in
                    Text(status.isEmpty ? "Any" : status)
                }
            }
            .pickerStyle(.menu)
            .accessibilityIdentifier("status-picker")
        }
    }
    
    func speciesSection() -> some View {
        Section("Species") {
            Picker("Species", selection: $filters.species) {
                ForEach(CharacterFilters.speciesOptions, id: \.self) { species in
                    Text(species.isEmpty ? "Any" : species)
                }
            }
            .pickerStyle(.menu)
            .accessibilityIdentifier("species-picker")
        }
    }
    
    func typeSection() -> some View {
        Section("Type") {
            TextField("Type", text: $filters.type)
                .accessibilityIdentifier("type-field")
        }
    }
    
    func resetFilterSection() -> some View {
        Section {
            Button("Reset Filters") {
                filters = CharacterFilters()
            }
            .accessibilityIdentifier("reset-filters-button")
        }
    }
}

struct CharacterFilters {
    var status: String = ""
    var species: String = ""
    var type: String = ""
    
    static let statusOptions = ["", "Alive", "Dead", "Unknown"]
    static let speciesOptions = ["", "Human", "Alien", "Animal"]
    
    // Returns true if any filter is applied
    var hasActiveFilters: Bool {
        !status.isEmpty || !species.isEmpty || !type.isEmpty
    }
    
    // Reset all filters to default values
    mutating func reset() {
        status = ""
        species = ""
        type = ""
    }
}

#Preview {
    struct PreviewWrapper: View {
        @Namespace private var namespace
        var body: some View {
            FilterView(currentFilters: .init(), onApply: {_ in })
        }
    }
    return PreviewWrapper()
}
