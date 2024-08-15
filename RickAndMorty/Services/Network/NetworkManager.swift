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

    func request<T: Decodable>(endpoint: Endpoint, method: HTTPMethod) -> AnyPublisher<T, NetworkError> {
        guard let url = endpoint.url else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        return request(url: url, method: method)
    }

    func request<T: Decodable>(url: URL, method: HTTPMethod) -> AnyPublisher<T, NetworkError> {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                try ResponseHandler.handle(data: data, response: response, error: nil).get()
            }
            .mapError { error in
                if let networkError = error as? NetworkError {
                    return networkError
                }
                return NetworkError.requestFailed
            }
            .eraseToAnyPublisher()
    }
}
