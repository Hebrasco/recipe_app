//
//  ContentView.swift
//  Rezepte
//
//  Created by Daniel Bedrich on 13.02.20.
//  Copyright © 2020 Daniel Bedrich. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var selection = 0
    
    var body: some View {
        TabView(selection: $selection){
                NavigationView {
                    RecipeCategoryList(category: .init(.recipes))
                }
                .padding(.leading, 1)
                .tabItem {
                    VStack {
                        Image(systemName: "book")
                            .imageScale(.large)
                        Text("Rezepte")
                    }
                }
                .tag(0)
            RecipePlanView()
                .tabItem {
                    VStack {
                        Image(systemName: "calendar")
                            .imageScale(.large)
                        Text("Speiseplan")
                    }
                }
                .tag(1)
            SearchView()
                .tabItem {
                    VStack {
                        Image(systemName: "magnifyingglass")
                            .imageScale(.large)
                        Text("Suche")
                    }
                }
                .tag(2)
            ShoppingListView()
                .tabItem {
                    VStack {
                        Image(systemName: "tag")
                            .imageScale(.large)
                        Text("Einkaufsliste")
                    }
                }
                .tag(3)
            FavoritesView()
                .tabItem {
                    VStack {
                        Image(systemName: "heart")
                            .imageScale(.large)
                        Text("Favoriten")
                    }
                }
                .tag(4)
        }
        .accentColor(.init("AccentColor"))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
