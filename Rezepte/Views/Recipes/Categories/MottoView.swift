//
//  MottoView.swift
//  Rezepte
//
//  Created by Daniel Bedrich on 18.02.20.
//  Copyright © 2020 Daniel Bedrich. All rights reserved.
//

import SwiftUI

struct MottoView: View {
    let testRecipe = Recipe(image: "placeholder", title: "Bananenaufstrich", ingredients: [], intolerances: ["halal", "wheat"], category: "Frühstück", tags: "Erster, Zweiter, Dritter Tag", time: 30, difficulty: .medium)
    
    var body: some View {
        List {
            Category(name: "Fasching",
                      image: "carnevall",
                      destination: AnyView(FastFoodView()))
            Category(name: "Ostern",
                      image: "easter",
                      destination: AnyView(BakeView()))
            Category(name: "Halloween",
                      image: "halloween",
                      destination: AnyView(FruitsView()))
            Category(name: "Weihnachten",
                      image: "xmas",
                      destination: AnyView(SpreadView()))
            RecipeCard(recipe: testRecipe)
            RecipeCard(recipe: testRecipe)
        }
        .navigationBarTitle("Motto/Anlässe", displayMode: .inline)
    }
}

struct MottoView_Previews: PreviewProvider {
    static var previews: some View {
        MottoView()
    }
}
