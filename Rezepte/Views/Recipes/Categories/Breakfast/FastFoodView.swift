//
//  FastFoodView.swift
//  Rezepte
//
//  Created by Daniel Bedrich on 18.02.20.
//  Copyright © 2020 Daniel Bedrich. All rights reserved.
//

import SwiftUI

struct FastFoodView: View {
    let recipies: [Recipe]
    
    init() {
        let jsonParser = JSONParser()
        recipies = jsonParser.parseRecipes()
    }
    
    var body: some View {
        List {
            ForEach(recipies.indices, id: \.self) { index in
                RecipeCard(recipe: self.recipies[index])
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
