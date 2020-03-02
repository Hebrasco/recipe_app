//
//  FastFoodView.swift
//  Rezepte
//
//  Created by Daniel Bedrich on 18.02.20.
//  Copyright © 2020 Daniel Bedrich. All rights reserved.
//

import SwiftUI

struct FastFoodView: View {
    let recipes = Recipes.recipes
    
    var body: some View {
        List {
            ForEach(recipes.indices, id: \.self) { index in
                RecipeCard(recipe: self.recipes[index])
            }
        }
        .navigationBarTitle("Schnelle Rezepte")
    }
}

struct FastFoodView_Previews: PreviewProvider {
    static var previews: some View {
        FastFoodView()
    }
}