//
//  LunchView.swift
//  Rezepte
//
//  Created by Daniel Bedrich on 18.02.20.
//  Copyright © 2020 Daniel Bedrich. All rights reserved.
//

import SwiftUI

struct LunchView: View {
    let recipes = Recipes.recipes.filter {$0.primaryCategory.contains("Mittagessen")}
    
    var body: some View {
        List {
            Category(name: "Fleisch",
                     image: "meat",
                     destination: AnyView(MeatView()))
            Category(name: "Fish",
                     image: "fish",
                     destination: AnyView(FishView()))
            Category(name: "Vegetarisch",
                     image: "vegetarian",
                     destination: AnyView(VegetarianView()))
            Category(name: "Pasta & Co",
                     image: "pasta",
                     destination: AnyView(PastaView()))
            Category(name: "Süßes",
                     image: "sweets",
                     destination: AnyView(LunchSweetsView()))
            Category(name: "Suppen",
                     image: "soup",
                     destination: AnyView(SoupView()))
            ForEach(recipes.indices, id: \.self) { index in
                RecipeCard(recipe: self.recipes[index])
            }
        }
        .navigationBarTitle("Mittagessen")
    }
}

struct LunchView_Previews: PreviewProvider {
    static var previews: some View {
        LunchView()
    }
}
