//
//  NetworkError.swift
//  RickAndMorty
//
//  Created by A4reK0v on 14.08.2024.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case requestFailed
    case decodingError
    case unknownError
    case serverError(String)
}

struct ServerErrorResponse: Decodable {
    let error: String
}
