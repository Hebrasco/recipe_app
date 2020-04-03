//
//  RecipeSearchBarList.swift
//  Rezepte
//
//  Created by Daniel Bedrich on 02.04.20.
//  Copyright © 2020 Daniel Bedrich. All rights reserved.
//

import SwiftUI

struct RecipeSearchBarList: View {
    @ObservedObject var viewModel: SearchViewModel
    @State var recipes: [Recipe] = []
    @State var filters: [FilterViewModel.Filter] = []
    @State var showFilterSheet = false
    let categoryTitle: String
    
    init(categoryTitle: String) {
        self.categoryTitle = categoryTitle
        self.viewModel = SearchViewModel()
        self.showFilterSheet = false
        self.recipes = Recipes.getRecipes().filter{$0.secondaryCategory.contains(categoryTitle)}
    }
    
    var body: some View {
        VStack {
            SearchBar(text: $viewModel.searchText, placeholder: "Rezepte durchsuchen")
            List {
                ForEach(recipes.filter{
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
            self.recipes = Recipes.getRecipes().filter{$0.secondaryCategory.contains(self.categoryTitle)}
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
        .navigationBarTitle(categoryTitle)
        .navigationBarItems(trailing: Button(action: {
            self.showFilterSheet.toggle()
        }, label: {
            Image(systemName: "line.horizontal.3.decrease.circle")
        }))
    }
}

struct RecipeSearchBarList_Previews: PreviewProvider {
    static var previews: some View {
        RecipeSearchBarList(categoryTitle: "Obst")
    }
}
