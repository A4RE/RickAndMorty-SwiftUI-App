//
//  TabView.swift
//  RickAndMorty
//
//  Created by A4reK0v on 14.08.2024.
//

import SwiftUI

struct AppTabView: View {
    
    @State private var selectedTab = 1
    
    var body: some View {
        TabView(selection: $selectedTab) {
            CharactersView().tabItem {
                TabViewElement(name: "Characters", imageName: "house.fill")
            }.tag(1)
            LocationsView().tabItem {
                TabViewElement(name: "Locations", imageName: "location.fill")
            }.tag(2)
            EpisodesView().tabItem {
                TabViewElement(name: "Episodes", imageName: "books.vertical.fill")
            }.tag(3)
            SettingsView().tabItem {
                TabViewElement(name: "Settings", imageName: "gear")
            }.tag(4)
        }
    }
}

#Preview {
    AppTabView()
}
