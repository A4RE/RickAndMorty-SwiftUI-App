//
//  APIEndpoint.swift
//  RickAndMorty
//
//  Created by A4reK0v on 14.08.2024.
//

import Foundation

enum APIEndpoint {
    case characters
    case locations
    case episodes
    case characterDetail(id: Int)
    case locationDetail(id: Int)
    case episodeDetail(id: Int)
    
    var path: String {
        switch self {
        case .characters:
            return "/character"
        case .locations:
            return "/location"
        case .episodes:
            return "/episode"
        case .characterDetail(let id):
            return "/character/\(id)"
        case .locationDetail(let id):
            return "/location/\(id)"
        case .episodeDetail(let id):
            return "/episode/\(id)"
        }
    }
}

