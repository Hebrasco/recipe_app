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
            RecipesView()
                .tabItem {
                    VStack {
                        Image("first")
                        Text("Rezepte")
                    }
                }
                .tag(0)
            RecipePlanView()
                .tabItem {
                    VStack {
                        Image("second")
                        Text("Wochenplan")
                    }
                }
                .tag(1)
            SearchView()
                .tabItem {
                    VStack {
                        Image("first")
                        Text("Suche")
                    }
                }
                .tag(2)
            ShoppingListView()
                .tabItem {
                    VStack {
                        Image("second")
                        Text("Einkaufsliste")
                    }
                }
                .tag(3)
            FavoritesView()
                .tabItem {
                    VStack {
                        Image("first")
                        Text("Favoriten")
                    }
                }
                .tag(3)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
