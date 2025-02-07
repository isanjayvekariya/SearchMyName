//
//  Character.swift
//  SearchMyName
//
//  Created by Sanjay Vekariya on 2/6/25.
//

// MARK: - Models
struct Character: Codable, Identifiable {
    let id: Int
    let name: String
    let species: String
    let image: String
    let status: String
    let type: String
    let created: String
    let origin: Origin
}

struct Origin: Codable {
    let name: String
}

struct CharacterResponse: Codable {
    let results: [Character]
}
