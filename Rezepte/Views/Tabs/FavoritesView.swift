//
//  FavoritesView.swift
//  Rezepte
//
//  Created by Daniel Bedrich on 13.02.20.
//  Copyright © 2020 Daniel Bedrich. All rights reserved.
//

import SwiftUI

struct FavoritesView: View {
    @ObservedObject var viewModel = FavoritesViewModel()
    var recipes = Recipes.recipes
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $viewModel.searchText, placeholder: "Favoriten durchsuchen")
                List {
                    ForEach(recipes.filter{$0.isFavorite}, id: \.id) { recipe in
                        RecipeCard(recipe)
                    }
                }
            }
            .resignKeyboardOnDragGesture()
            .navigationBarTitle("Favoriten")
        }
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}
