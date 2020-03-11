//
//  EasterView.swift
//  Rezepte
//
//  Created by Daniel Bedrich on 20.02.20.
//  Copyright © 2020 Daniel Bedrich. All rights reserved.
//

import SwiftUI

struct EasterView: View {
    @ObservedObject var viewModel = SearchViewModel()
    let recipes = Recipes.recipes.filter {$0.secondaryCategory.contains("Ostern")}
    
    var body: some View {
        VStack {
            SearchBar(text: $viewModel.searchText, placeholder: "Rezepte durchsuchen")
            List {
                ForEach(recipes.filter{
                    if viewModel.searchText.isEmpty {
                        return true
                    } else {
                        return $0.title.contains(viewModel.searchText)
                    }
                }, id: \.id) { recipe in
                    RecipeCard(recipe)
                }
            }
        }
        .navigationBarTitle("Ostern")
    }
}

struct EasterView_Previews: PreviewProvider {
    static var previews: some View {
        EasterView()
    }
}
