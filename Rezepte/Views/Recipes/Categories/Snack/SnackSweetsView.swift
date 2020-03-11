//
//  SnackSweetsView.swift
//  Rezepte
//
//  Created by Daniel Bedrich on 20.02.20.
//  Copyright © 2020 Daniel Bedrich. All rights reserved.
//

import SwiftUI

struct SnackSweetsView: View {
    @State var searchText = ""
    let recipes = Recipes.recipes.filter {$0.secondaryCategory.contains("Süßes")}
    
    var body: some View {
        VStack {
            SearchBar(text: $searchText, placeholder: "Rezepte durchsuchen")
            List {
                ForEach(recipes, id: \.id) { recipe in
                    RecipeCard(recipe: recipe)
                }
            }
        }
        .navigationBarTitle("Süßes")
    }
}

struct SnackSweetsView_Previews: PreviewProvider {
    static var previews: some View {
        SnackSweetsView()
    }
}
