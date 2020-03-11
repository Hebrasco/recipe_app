//
//  SearchView.swift
//  Rezepte
//
//  Created by Daniel Bedrich on 13.02.20.
//  Copyright © 2020 Daniel Bedrich. All rights reserved.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var viewModel = SearchViewModel()
    let recipes = Recipes.recipes
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $viewModel.searchText)
                List {
                    ForEach(recipes.filter{
                        if viewModel.searchText.isEmpty {
                            return true
                        } else {
                            return $0.title.contains(viewModel.searchText)
                        }
                    }, id: \.id) { recipe in
                        RecipeCard(recipe: recipe)
                    }
                }
            }
            .resignKeyboardOnDragGesture()
            .navigationBarTitle("Suche")
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
