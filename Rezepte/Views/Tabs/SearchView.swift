//
//  SearchView.swift
//  Rezepte
//
//  Created by Daniel Bedrich on 13.02.20.
//  Copyright © 2020 Daniel Bedrich. All rights reserved.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject private var viewModel = SearchViewController()
    @State private var filters: [FilterController.Filter] = []
    @State private var recipes: [Recipe] = []
    @State private var showFilterSheet = false
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $viewModel.searchText)
                List {
                    ForEach(recipes.filter {
                        if viewModel.searchText.isEmpty {
                            return true && viewModel.filterViewModel.recipeContainsActiveFilterIntolerance($0, filters: filters)
                        } else {
                            return ($0.title.contains(viewModel.searchText) || $0.tags.contains(viewModel.searchText)) && viewModel.filterViewModel.recipeContainsActiveFilterIntolerance($0, filters: filters)
                        }
                    }, id: \.id) { recipe in
                        RecipeCard(recipe, with: .Navigation)
                    }
                }
            }
            .onAppear(perform: {
                self.recipes = Recipes.getRecipes()
                self.filters = self.viewModel.filterViewModel.loadFilters()
            })
            .resignKeyboardOnDragGesture()
            .sheet(isPresented: $showFilterSheet,
                   onDismiss: {
                    self.viewModel.filterViewModel.saveFilters(self.filters)
                    self.filters = self.viewModel.filterViewModel.loadFilters()},
                   content: {
                    Filter(viewModel: self.viewModel.filterViewModel, filters: self.$filters,
                           showSheet: self.$showFilterSheet)
                        .accentColor(.init("AccentColor"))
            })
            .navigationBarTitle("Suche")
            .navigationBarItems(trailing: Button(action: {
                self.showFilterSheet.toggle()
            }, label: {
                Image(systemName: "line.horizontal.3.decrease.circle")
                    .imageScale(.large)
            }))
        }
        .padding(.leading, 1)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
