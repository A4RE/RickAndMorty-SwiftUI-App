//
//  InfoModel.swift
//  RickAndMorty
//
//  Created by A4reK0v on 14.08.2024.
//

import Foundation

struct Info: Decodable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}
