//
//  TabViewElement.swift
//  RickAndMorty
//
//  Created by A4reK0v on 14.08.2024.
//

import SwiftUI

struct TabViewElement: View {
    
    var name: String
    var imageName: String
    
    var body: some View {
        VStack {
            Image(systemName: imageName)
            Text(name)
        }
    }
}

#Preview {
    TabViewElement(name: "home", imageName: "house.fill")
}
