//
//  HalloweenView.swift
//  Rezepte
//
//  Created by Daniel Bedrich on 20.02.20.
//  Copyright © 2020 Daniel Bedrich. All rights reserved.
//

import SwiftUI

struct HalloweenView: View {
    @State var searchText = ""
    let recipes = Recipes.recipes.filter {$0.secondaryCategory.contains("Halloween")}
    
    var body: some View {
        VStack {
            SearchBar(text: $searchText, placeholder: "Rezepte durchsuchen")
            List {
                ForEach(recipes, id: \.id) { recipe in
                    RecipeCard(recipe: recipe)
                }
            }
        }
        .navigationBarTitle("Halloween")
    }
}

struct HalloweenView_Previews: PreviewProvider {
    static var previews: some View {
        HalloweenView()
    }
}
