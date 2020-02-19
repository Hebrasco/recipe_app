//
//  SnackView.swift
//  Rezepte
//
//  Created by Daniel Bedrich on 18.02.20.
//  Copyright © 2020 Daniel Bedrich. All rights reserved.
//

import SwiftUI

struct SnackView: View {
    let recipies: [Recipe]
    
    init() {
        let jsonParser = JSONParser()
        recipies = jsonParser.parse()
    }
    
    var body: some View {
        List {
            Category(name: "Obst",
                      image: "fruits",
                      destination: AnyView(FastFoodView()))
            Category(name: "Quark & Co",
                      image: "quark",
                      destination: AnyView(BakeView()))
            Category(name: "Süßes",
                      image: "sweets",
                      destination: AnyView(FruitsView()))
            Category(name: "Herzhaftes",
                      image: "hearty",
                      destination: AnyView(SpreadView()))
            ForEach(recipies.indices, id: \.self) { index in
                RecipeCard(recipe: self.recipies[index])
            }
        }
        .navigationBarTitle("Nachtisch/Snack")
    }
}

struct SnackView_Previews: PreviewProvider {
    static var previews: some View {
        SnackView()
    }
}
