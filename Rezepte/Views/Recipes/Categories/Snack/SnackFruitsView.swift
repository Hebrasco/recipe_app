//
//  SnackFruitsView.swift
//  Rezepte
//
//  Created by Daniel Bedrich on 20.02.20.
//  Copyright © 2020 Daniel Bedrich. All rights reserved.
//

import SwiftUI

struct SnackFruitsView: View {
    @State var searchText = ""
    let recipes = Recipes.recipes.filter {$0.secondaryCategory.contains("Obst")}
    
    var body: some View {
        VStack {
            SearchBar(text: $searchText, placeholder: "Rezepte durchsuchen")
            List {
                ForEach(recipes.indices, id: \.self) { index in
                    RecipeCard(recipe: self.recipes[index])
                }
            }
        }
        .navigationBarTitle("Obst")
    }
}

struct SnackFruitsView_Previews: PreviewProvider {
    static var previews: some View {
        SnackFruitsView()
    }
}
