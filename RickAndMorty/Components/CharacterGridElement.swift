//
//  CharacterGridElement.swift
//  RickAndMorty
//
//  Created by A4reK0v on 15.08.2024.
//

import SwiftUI
import Kingfisher

struct CharacterGridElement: View {
    
    var imageURL: String
    var charName: String
    var charSpecies: String
    var origin: String
    
    @State private var isLoading = true
    @State private var isError = false
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                kfImage
                
                if isLoading && !isError {
                    progressView
                }
                
                if isError {
                    errorView
                }
            }
            
            charInfo
        }
        .background(RoundedRectangle(cornerRadius: screenWidth / 30)
            .foregroundColor(.white)
            .shadow(color: .black.opacity(0.1), radius: screenWidth / 20, x: screenWidth / 10, y: screenWidth / 10))
    }
}

// MARK: UI Setup
private extension CharacterGridElement {
    
    private var kfImage: some View {
        KFImage(URL(string: imageURL))
            .resizable()
            .onSuccess { _ in
                isLoading = false
                isError = false
            }
            .onFailure { _ in
                isLoading = false
                isError = true
            }
            .onAppear {
                isLoading = true
                isError = false
            }
            .aspectRatio(contentMode: .fit)
            .opacity(isLoading || isError ? 0 : 1)
            .cornerRadius(screenWidth / 30, corners: [.topLeft, .topRight])
    }
    
    private var progressView: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle())
            .frame(width: 100, height: 100)
    }
    
    private var errorView: some View {
        Image(systemName: "exclamationmark.triangle")
            .resizable()
            .scaledToFit()
            .frame(width: 100, height: 100)
            .foregroundColor(.red)
    }
    
    private var charInfo: some View {
        VStack(alignment: .leading) {
            Text(charName)
                .font(.headline)
                .fontWeight(.semibold)
                .multilineTextAlignment(.leading)
                .lineLimit(1)
            Text(charSpecies)
                .font(.subheadline)
                .fontWeight(.light)
                .multilineTextAlignment(.leading)
                .lineLimit(2)
            Text(origin == "unknown" ? "-" : origin)
                .font(.subheadline)
                .fontWeight(.light)
                .multilineTextAlignment(.leading)
                .lineLimit(1)
        }
        .padding(.top, screenWidth / 50)
        .padding(.bottom, screenWidth / 30)
        .padding(.horizontal, screenWidth / 50)
    }
}
