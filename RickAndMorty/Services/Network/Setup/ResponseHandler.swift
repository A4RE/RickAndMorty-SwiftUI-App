//
//  ResponseHandler.swift
//  RickAndMorty
//
//  Created by A4reK0v on 14.08.2024.
//

import Foundation

final class ResponseHandler {
    static func handle<T: Decodable>(data: Data?, response: URLResponse?, error: Error?) -> Result<T, NetworkError> {
        if error != nil {
            return .failure(.requestFailed)
        }

        guard let data = data else {
            return .failure(.unknownError)
        }

        if let httpResponse = response as? HTTPURLResponse {
            guard (200...299).contains(httpResponse.statusCode) else {
                // Attempt to decode the error message from the server
                if let serverError = try? JSONDecoder().decode(ServerErrorResponse.self, from: data) {
                    return .failure(.serverError(serverError.error))
                }
                return .failure(.requestFailed)
            }
        } else {
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
