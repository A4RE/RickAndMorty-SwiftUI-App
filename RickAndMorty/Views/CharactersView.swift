//
//  CharactersView.swift
//  RickAndMorty
//
//  Created by A4reK0v on 14.08.2024.
//

import SwiftUI

struct CharactersView: View {
    
    @ObservedObject private var viewModel = CharactersViewModel()
    
    var body: some View {
        NavigationStack {
            scrollViewContainer
            .navigationTitle("Characters")
            .searchable(text: $viewModel.searchName, prompt: "Character name...")
            .onAppear {
                if viewModel.characters.isEmpty {
                    viewModel.fetchCharacters()
                }
            }
            .onChange(of: viewModel.searchName) { newValue in
                viewModel.searchCharacters(by: newValue)
            }
            .alert(isPresented: .constant(viewModel.errorMessage != nil)) {
                Alert(
                    title: Text("Error"),
                    message: Text(viewModel.errorMessage ?? "Unknown error"),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}

// MARK: UI Setup
private extension CharactersView {
    
    private var charactersGrid: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(minimum: screenWidth / 2.5, maximum: screenWidth / 2.5), spacing: screenWidth / 20),
                GridItem(.flexible(minimum: screenWidth / 2.5, maximum: screenWidth / 2.5), spacing: screenWidth / 20)
            ])
        {
            ForEach(viewModel.characters) { character in
                CharacterGridElement(imageURL: character.image, charName: character.name, charSpecies: character.species, origin: character.origin.name)
                    .onAppear {
                        if character == viewModel.characters.last {
                            viewModel.fetchCharacters()
                        }
                    }
            }
        }
    }
    
    private var loadingPlaceholder: some View {
        HStack {
            Spacer()
            ProgressView("Loading more characters...")
            Spacer()
        }
        .padding()
    }
    
    private var scrollViewContainer: some View {
        ScrollView(showsIndicators: false) {
            if viewModel.isEmptyState {
                emptyView
            } else {
                charactersGrid
            }
            
            if viewModel.isLoading {
                loadingPlaceholder
            }
        }
    }
    
    private var emptyView: some View {
        VStack {
            if #available(iOS 17.0, *) {
                ContentUnavailableView("No Results", systemImage: "magnifyingglass", description: Text("Check the spelling or try a new search."))
            } else {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .scaledToFit()
                    .fontWeight(.semibold)
                    .frame(width: screenWidth / 8, height: screenWidth / 8, alignment: .center)
                    .foregroundStyle(.secondary)
            Text("No Results")
                .font(.title3)
                .fontWeight(.bold)
                .padding(.top, 5)
            Text("Check the spelling or try a new search.")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
            }
        }
        .position(x: screenWidth / 2, y: screenHeight / 4)
    }
}

#Preview {
    CharactersView()
}
