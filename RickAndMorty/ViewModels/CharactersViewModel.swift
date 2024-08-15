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
    @Published var isLoading = false
    private var cancellables = Set<AnyCancellable>()
    private var nextPageURL: String? = nil
    
    func fetchCharacters() {
        guard !isLoading else { return }
        isLoading = true
        
        let publisher: AnyPublisher<CharacterResponse, NetworkError>
        if let nextPage = nextPageURL, let url = URL(string: nextPage) {
            publisher = NetworkManager.shared.request(url: url, method: .get)
        } else {
            let charactersEndpoint = Endpoint(apiEndpoint: .characters, queryItems: [URLQueryItem(name: "page", value: "1")])
            publisher = NetworkManager.shared.request(endpoint: charactersEndpoint, method: .get)
        }
        
        publisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                switch completion {
                case .failure(let error):
                    self.errorMessage = "Failed to load characters: \(error.localizedDescription)"
                case .finished:
                    break
                }
            } receiveValue: { [weak self] (response: CharacterResponse) in
                guard let self = self else { return }
                self.characters.append(contentsOf: response.results)
                self.nextPageURL = response.info.next
            }
            .store(in: &cancellables)
    }
}
