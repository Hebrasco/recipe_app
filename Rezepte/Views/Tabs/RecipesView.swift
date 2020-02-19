//
//  RecipesView.swift
//  Rezepte
//
//  Created by Daniel Bedrich on 13.02.20.
//  Copyright © 2020 Daniel Bedrich. All rights reserved.
//

import SwiftUI

struct RecipesView: View {
    @ObservedObject var viewModel = RecipesViewModel()
    let recipies: [Recipe]
    
    init() {
        let jsonParser = JSONParser()
        recipies = jsonParser.parseFile(name: "Recipes", type: "json")
    }
    
    var body: some View {
        NavigationView {
            List {
                Category(name: "Früchstück",
                         image: "breakfast",
                         destination: AnyView(BreakfastView()))
                Category(name: "Mittagessen",
                         image: "lunch",
                         destination: AnyView(LunchView()))
                Category(name: "Nachtisch/Snack",
                         image: "snack",
                         destination: AnyView(SnackView()))
                Category(name: "Motto/Anlässe",
                         image: "motto",
                         destination: AnyView(MottoView()))
                ForEach(recipies.indices, id: \.self) { index in
                    RecipeCard(recipe: self.recipies[index])
                }
            }
            .navigationBarTitle("Rezepte")
        }
    }
}

struct RecipesView_Previews: PreviewProvider {
    static var previews: some View {
        RecipesView()
    }
}
