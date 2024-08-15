//
//  RMCharacterModel.swift
//  RickAndMorty
//
//  Created by A4reK0v on 14.08.2024.
//

import Foundation

struct CharacterResponse: Decodable {
    let info: Info
    let results: [RMCharacter]
}

struct RMCharacter: Decodable, Identifiable, Equatable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let origin: Origin
    let location: Location
    let image: String
    let episode: [String]
    let url: String
    let created: String
    
    static func ==(lhs: RMCharacter, rhs: RMCharacter) -> Bool {
        return lhs.id == rhs.id
    }
}

struct Origin: Decodable {
    let name: String
    let url: String
}

struct Location: Decodable {
    let name: String
    let url: String
}
