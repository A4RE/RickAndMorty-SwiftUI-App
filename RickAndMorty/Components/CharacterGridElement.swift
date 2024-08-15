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
    
    @State private var isLoading = true
    @State private var isError = false
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                KFImage(URL(string: imageURL))
                    .resizable()
                    .cacheOriginalImage()
                    .setProcessor(DownsamplingImageProcessor(size: CGSize(width: 120, height: 120)))
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
                    .frame(width: 120, height: 120, alignment: .center)
                    .opacity(isLoading || isError ? 0 : 1)
                
                if isLoading && !isError {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .frame(width: 100, height: 100)
                }
                
                if isError {
                    Image(systemName: "exclamationmark.triangle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.red)
                }
            }

            Text(charName)
                .font(.headline)
                .fontWeight(.semibold)
                .padding(.top, 5)
                .multilineTextAlignment(.leading)
                .lineLimit(2)
                .frame(maxWidth: 120, alignment: .leading)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(.blue.opacity(0.2))
        )
        .clipped()
    }
}
