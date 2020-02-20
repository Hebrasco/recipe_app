//
//  SnackFruitsView.swift
//  Rezepte
//
//  Created by Daniel Bedrich on 20.02.20.
//  Copyright © 2020 Daniel Bedrich. All rights reserved.
//

import SwiftUI

struct SnackFruitsView: View {
    
    let recipes = Recipes.recipes
    
    var body: some View {
        List {
            ForEach(recipes.indices, id: \.self) { index in
                RecipeCard(recipe: self.recipes[index])
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
