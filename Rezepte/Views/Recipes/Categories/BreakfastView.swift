//
//  BreakfastView.swift
//  Rezepte
//
//  Created by Daniel Bedrich on 18.02.20.
//  Copyright © 2020 Daniel Bedrich. All rights reserved.
//

import SwiftUI

struct BreakfastView: View {
    let testRecipe = Recipe(image: "placeholder", title: "Bananenaufstrich", ingredients: [], intolerances: ["halal", "wheat"], category: "Frühstück", tags: "Erster, Zweiter, Dritter Tag", time: 30, difficulty: .medium)

    var body: some View {
        List {
            Category(name: "Schnelle Rezepte",
                      image: "fastfood",
                      destination: AnyView(FastFoodView()))
            Category(name: "Backen",
                      image: "bake",
                      destination: AnyView(BakeView()))
            Category(name: "Obst",
                      image: "fruits",
                      destination: AnyView(FruitsView()))
            Category(name: "Aufstriche",
                      image: "spread",
                      destination: AnyView(SpreadView()))
            RecipeCard(recipe: testRecipe)
            RecipeCard(recipe: testRecipe)
        }
        .navigationBarTitle("Frühstück", displayMode: .inline)
    }
}

struct BreakfastView_Previews: PreviewProvider {
    static var previews: some View {
        BreakfastView()
    }
}
