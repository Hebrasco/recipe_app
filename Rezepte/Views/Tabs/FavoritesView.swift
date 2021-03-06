//
//  FavoritesView.swift
//  Rezepte
//
//  Created by Daniel Bedrich on 13.02.20.
//  Copyright © 2020 Daniel Bedrich. All rights reserved.
//

import SwiftUI

struct FavoritesView: View {
    @ObservedObject private var viewModel = FavoritesViewController()
    @State private var recipes: [Recipe] = []
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $viewModel.searchText, placeholder: "Favoriten durchsuchen")
                List {
                    ForEach(recipes.filter{
                        if viewModel.searchText.isEmpty {
                            return true
                        } else {
                            return $0.title.contains(viewModel.searchText) || $0.tags.contains(viewModel.searchText)
                        }}, id: \.id) { recipe in
                        RecipeCard(recipe, with: .Navigation)
                    }
                }
            }
            .onAppear(perform: {
                self.recipes = Recipes.getRecipes().filter{$0.isFavorite}
            })
            .resignKeyboardOnDragGesture()
            .navigationBarTitle("Favoriten")
        }
        .padding(.leading, 1)
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}
