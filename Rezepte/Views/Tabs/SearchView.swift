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
    @State var recipes: [Recipe] = []
    @State var showFilterSheet = false
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $viewModel.searchText)
                List {
                    ForEach(recipes.filter {
                        if viewModel.searchText.isEmpty {
                            return true && viewModel.filterViewModel.recipeContainsActiveFilterIntolerance($0)
                        } else {
                            return ($0.title.contains(viewModel.searchText) || $0.tags.contains(viewModel.searchText)) && viewModel.filterViewModel.recipeContainsActiveFilterIntolerance($0)
                        }
                    }, id: \.id) { recipe in
                        RecipeCard(recipe, with: .Navigation)
                    }
                }
            }
            .onAppear(perform: {
                self.recipes = Recipes.getRecipes()
                self.viewModel.filterViewModel.loadFilters()
            })
            .resignKeyboardOnDragGesture()
            .sheet(isPresented: $showFilterSheet,
                   onDismiss: {
                    self.viewModel.filterViewModel.saveFilters()
                    self.viewModel.filterViewModel.loadFilters()},
                   content: {
                    Filter(viewModel: self.$viewModel.filterViewModel,
                           showSheet: self.$showFilterSheet)
                        .accentColor(.init("AccentColor"))
            })
            .navigationBarTitle("Suche")
            .navigationBarItems(trailing: Button(action: {
                self.showFilterSheet.toggle()
            }, label: {
                Image(systemName: "line.horizontal.3.decrease.circle")
            }))
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
