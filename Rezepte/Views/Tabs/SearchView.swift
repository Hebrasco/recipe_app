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
    @State var showCancelButton = false
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(searchText: $viewModel.searchText)
                List {
                    ForEach(recipes.indices, id: \.self) { index in
                        RecipeCard(recipe: self.recipes[index])
                    }
                }
            }
            .resignKeyboardOnDragGesture()
            .navigationBarTitle("Search")
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
