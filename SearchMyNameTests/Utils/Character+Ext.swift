//
//  Character+Ext.swift
//  SearchMyName
//
//  Created by Sanjay Vekariya on 2/7/25.
//

@testable import SearchMyName

extension Character {
    static func mockCharacter(
        id: Int = 1,
        name: String = "Sanjay Vekariya",
        status: String = "Alive",
        species: String = "Human",
        type: String = ""
    ) -> Character {
        .init(
            id: id,
            name: name,
            species: species,
            image: "https://rickandmortyapi.com/api/character/avatar/\(id).jpeg",
            status: status,
            type: type,
            created: "2025-02-07T18:48:46.250Z",
            origin: Origin(name: "Earth")
        )
    }
}
