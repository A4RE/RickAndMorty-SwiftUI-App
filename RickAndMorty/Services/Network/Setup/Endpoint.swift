//
//  Endpoint.swift
//  RickAndMorty
//
//  Created by A4reK0v on 14.08.2024.
//

import Foundation

struct Endpoint {
    let apiEndpoint: APIEndpoint
    var queryItems: [URLQueryItem] = []

    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "rickandmortyapi.com"
        components.path = "/api" + apiEndpoint.path
        components.queryItems = queryItems.isEmpty ? nil : queryItems
        return components.url
    }
}

