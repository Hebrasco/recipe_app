//
//  BreakfastView.swift
//  Rezepte
//
//  Created by Daniel Bedrich on 18.02.20.
//  Copyright © 2020 Daniel Bedrich. All rights reserved.
//

import SwiftUI

struct BreakfastView: View {
    let recipes = Recipes.recipes

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
                     destination: AnyView(BreakfastFruitsView()))
            Category(name: "Aufstriche",
                     image: "spread",
                     destination: AnyView(SpreadView()))
            ForEach(recipes.indices, id: \.self) { index in
                RecipeCard(recipe: self.recipes[index])
            }
        }
        .navigationBarTitle("Frühstück")
    }
}

struct BreakfastView_Previews: PreviewProvider {
    static var previews: some View {
        BreakfastView()
    }
}