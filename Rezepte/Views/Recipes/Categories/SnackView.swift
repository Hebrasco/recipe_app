//
//  SnackView.swift
//  Rezepte
//
//  Created by Daniel Bedrich on 18.02.20.
//  Copyright © 2020 Daniel Bedrich. All rights reserved.
//

import SwiftUI

struct SnackView: View {
    @State var recipes: [Recipe] = Recipes.getRecipes().filter{$0.primaryCategory.contains("Nachtisch/Snack")}
    
    var body: some View {
        List {
            Category(name: "Obst",
                     image: "fruits",
                     destination: AnyView(SnackFruitsView()))
            Category(name: "Quark & Co",
                     image: "quark",
                     destination: AnyView(QuarkView()))
            Category(name: "Süßes",
                     image: "sweets",
                     destination: AnyView(SnackSweetsView()))
            Category(name: "Herzhaftes",
                     image: "hearty",
                     destination: AnyView(HeartyView()))
            ForEach(recipes, id: \.id) { recipe in
                RecipeCard(recipe, with: .Navigation)
            }
        }
        .onAppear(perform: {
            self.recipes = Recipes.getRecipes().filter{$0.primaryCategory.contains("Nachtisch/Snack")}
        })
        .navigationBarTitle("Nachtisch/Snack")
    }
}

struct SnackView_Previews: PreviewProvider {
    static var previews: some View {
        SnackView()
    }
}
