//
//  CharactersView.swift
//  RickAndMorty
//
//  Created by A4reK0v on 14.08.2024.
//

import SwiftUI

struct CharactersView: View {
    
    @ObservedObject private var viewModel = CharactersViewModel()
    
    let columns = [
        GridItem(.fixed(150)),
        GridItem(.fixed(150))
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(viewModel.characters) { character in
                        CharacterGridElement(imageURL: character.image, charName: character.name)
                            .onAppear {
                                if character == viewModel.characters.last {
                                    viewModel.fetchCharacters()
                                }
                            }
                    }
                }
                
                if viewModel.isLoading {
                    HStack {
                        Spacer()
                        ProgressView("Loading more characters...")
                        Spacer()
                    }
                    .padding()
                }
            }
            .navigationTitle("Characters")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Image(systemName: "magnifyingglass")
                }
            }
            .onAppear {
                viewModel.fetchCharacters()
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

#Preview {
    CharactersView()
}
