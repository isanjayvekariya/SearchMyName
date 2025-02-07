//
//  Character.swift
//  SearchMyName
//
//  Created by Sanjay Vekariya on 2/6/25.
//

import Foundation

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

// MARK: - Date Formatter
extension Character {
    var formattedCreatedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        guard let date = dateFormatter.date(from: created) else { return created }
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }
}
