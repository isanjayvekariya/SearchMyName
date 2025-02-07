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
                Section("Status") {
                    Picker("Status", selection: $filters.status) {
                        ForEach(CharacterFilters.statusOptions, id: \.self) { status in
                            Text(status.isEmpty ? "Any" : status)
                        }
                    }
                    .pickerStyle(.menu)
                    .accessibilityIdentifier("status-picker")
                }
                
                Section("Species") {
                    Picker("Species", selection: $filters.species) {
                        ForEach(CharacterFilters.speciesOptions, id: \.self) { species in
                            Text(species.isEmpty ? "Any" : species)
                        }
                    }
                    .pickerStyle(.menu)
                    .accessibilityIdentifier("species-picker")
                }
                
                Section("Type") {
                    TextField("Type", text: $filters.type)
                        .accessibilityIdentifier("type-field")
                }
                
                Section {
                    Button("Reset Filters") {
                        filters = CharacterFilters()
                    }
                    .accessibilityIdentifier("reset-filters-button")
                }
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
