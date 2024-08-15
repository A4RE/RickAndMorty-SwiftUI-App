//
//  ContentTypeViewModel.swift
//  RickAndMorty
//
//  Created by A4reK0v on 14.08.2024.
//

import Foundation
import Combine

final class CharactersViewModel: ObservableObject {
    @Published var characters: [RMCharacter] = []
    @Published var errorMessage: String? = nil
    @Published var searchName = ""
    @Published var isLoading = false
    @Published var isEmptyState = false
    
    private var cancellables = Set<AnyCancellable>()
    private var nextPageURL: String? = nil
    
    func fetchCharacters() {
        guard !isLoading else { return }
        isLoading = true
        isEmptyState = false
        
        let publisher: AnyPublisher<CharacterResponse, NetworkError>
        
        if let nextPage = nextPageURL, let url = URL(string: nextPage) {
            publisher = NetworkManager.shared.request(url: url, method: .get)
        } else {
            var queryItems = [URLQueryItem(name: "page", value: "1")]
            if !searchName.isEmpty {
                queryItems.append(URLQueryItem(name: "name", value: searchName))
            }
            let charactersEndpoint = Endpoint(apiEndpoint: .characters, queryItems: queryItems)
            publisher = NetworkManager.shared.request(endpoint: charactersEndpoint, method: .get)
        }
        
        
        publisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                switch completion {
                case .failure(let error):
                    if self.parseError(error) == "There is nothing here" {
                        self.isEmptyState = true
                    } else {
                        self.errorMessage = self.parseError(error)
                    }
                case .finished:
                    break
                }
            } receiveValue: { [weak self] (response: CharacterResponse) in
                guard let self = self else { return }
                
                if let errorMessage = response.error {
                    self.errorMessage = errorMessage
                    self.isEmptyState = true
                    return
                }
                
                if let results = response.results, !results.isEmpty {
                    self.characters.append(contentsOf: results)
                    self.nextPageURL = response.info?.next
                } else {
                    self.isEmptyState = true
                }
            }
            .store(in: &cancellables)
    }
    
    private func parseError(_ error: NetworkError) -> String {
        switch error {
        case .serverError(let message):
            return message
        default:
            return "Failed to load characters: \(error.localizedDescription)"
        }
    }
    
    func searchCharacters(by name: String) {
        self.searchName = name
        self.nextPageURL = nil
        self.characters = []
        self.fetchCharacters()
    }
}

