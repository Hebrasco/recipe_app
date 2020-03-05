//
//  SpreadView.swift
//  Rezepte
//
//  Created by Daniel Bedrich on 18.02.20.
//  Copyright © 2020 Daniel Bedrich. All rights reserved.
//

import SwiftUI

struct SpreadView: View {
    @State var searchText = ""
    let recipes = Recipes.recipes
    
    var body: some View {
        VStack {
            SearchBar(searchText: $searchText)
            List {
                ForEach(recipes.indices, id: \.self) { index in
                    RecipeCard(recipe: self.recipes[index])
                }
            }
        }
        .navigationBarTitle("Aufstriche")
    }
}

struct SpreadView_Previews: PreviewProvider {
    static var previews: some View {
        SpreadView()
    }
}
