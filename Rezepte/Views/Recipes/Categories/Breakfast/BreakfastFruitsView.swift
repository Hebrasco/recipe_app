//
//  BreakfastFruitsView.swift
//  Rezepte
//
//  Created by Daniel Bedrich on 18.02.20.
//  Copyright © 2020 Daniel Bedrich. All rights reserved.
//

import SwiftUI

struct BreakfastFruitsView: View {
    @State var searchText = ""
    let recipes = Recipes.recipes.filter {$0.secondaryCategory.contains("Obst")}
    
    var body: some View {
        VStack {
            SearchBar(text: $searchText, placeholder: "Rezepte durchsuchen")
            List {
                ForEach(recipes, id: \.id) { recipe in
                    RecipeCard(recipe: recipe)
                }
            }
        }
        .navigationBarTitle("Obst")
    }
}

struct FruitsView_Previews: PreviewProvider {
    static var previews: some View {
        BreakfastFruitsView()
    }
}
