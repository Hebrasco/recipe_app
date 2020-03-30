//
//  SoupView.swift
//  Rezepte
//
//  Created by Daniel Bedrich on 18.02.20.
//  Copyright © 2020 Daniel Bedrich. All rights reserved.
//

import SwiftUI

struct SoupView: View {
    @ObservedObject var viewModel = SearchViewModel()
    @State var recipes: [Recipe] = Recipes.getRecipes().filter{$0.secondaryCategory.contains("Suppe")}
    
    var body: some View {
        VStack {
            SearchBar(text: $viewModel.searchText, placeholder: "Rezepte durchsuchen")
            List {
                ForEach(recipes.filter{
                    if viewModel.searchText.isEmpty {
                        return true
                    } else {
                        return $0.title.contains(viewModel.searchText) || $0.tags.contains(viewModel.searchText)
                    }
                }, id: \.id) { recipe in
                    RecipeCard(recipe, with: .Navigation)
                }
            }
        }
        .onAppear(perform: {
            self.recipes = Recipes.getRecipes().filter{$0.secondaryCategory.contains("Suppe")}
        })
        .resignKeyboardOnDragGesture()
        .navigationBarTitle("Suppen")
    }
}

struct SoupView_Previews: PreviewProvider {
    static var previews: some View {
        SoupView()
    }
}
