//
//  EasterView.swift
//  Rezepte
//
//  Created by Daniel Bedrich on 20.02.20.
//  Copyright © 2020 Daniel Bedrich. All rights reserved.
//

import SwiftUI

struct EasterView: View {
    @State var searchText = ""
    let recipes = Recipes.recipes
    
    var body: some View {
        VStack {
            SearchBar(text: $searchText, placeholder: "Rezepte durchsuchen")
            List {
                ForEach(recipes.indices, id: \.self) { index in
                    RecipeCard(recipe: self.recipes[index])
                }
            }
        }
        .navigationBarTitle("Ostern")
    }
}

struct EasterView_Previews: PreviewProvider {
    static var previews: some View {
        EasterView()
    }
}
