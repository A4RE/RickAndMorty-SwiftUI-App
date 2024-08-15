//
//  NetworkManager.swift
//  RickAndMorty
//
//  Created by A4reK0v on 14.08.2024.
//

import Foundation
import Combine

final class NetworkManager {
    static let shared = NetworkManager()

    private init() {}

    // Original method using Endpoint
    func request<T: Decodable>(endpoint: Endpoint, method: HTTPMethod) -> AnyPublisher<T, NetworkError> {
        guard let url = endpoint.url else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        return request(url: url, method: method)
    }

    // Overloaded method using a direct URL
    func request<T: Decodable>(url: URL, method: HTTPMethod) -> AnyPublisher<T, NetworkError> {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw NetworkError.requestFailed
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                if let decodingError = error as? DecodingError {
                    print("Decoding error: \(decodingError)")
                    return NetworkError.decodingError
                }
                return NetworkError.requestFailed
            }
            .eraseToAnyPublisher()
    }
}
