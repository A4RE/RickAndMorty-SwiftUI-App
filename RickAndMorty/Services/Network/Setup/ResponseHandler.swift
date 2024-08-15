//
//  ResponseHandler.swift
//  RickAndMorty
//
//  Created by A4reK0v on 14.08.2024.
//

import Foundation

final class ResponseHandler {
    static func handle<T: Decodable>(data: Data?, response: URLResponse?, error: Error?) -> Result<T, NetworkError> {
        guard error == nil else {
            return .failure(.requestFailed)
        }

        guard let data = data else {
            return .failure(.unknownError)
        }

        do {
            let decodedObject = try JSONDecoder().decode(T.self, from: data)
            return .success(decodedObject)
        } catch {
            return .failure(.decodingError)
        }
    }
}
