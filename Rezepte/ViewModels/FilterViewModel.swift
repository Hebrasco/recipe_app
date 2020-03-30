//
//  FilterViewModel.swift
//  Rezepte
//
//  Created by Daniel Bedrich on 30.03.20.
//  Copyright © 2020 Daniel Bedrich. All rights reserved.
//

import Foundation

class FilterViewModel: ObservableObject {
    let intolerances: [Recipe.Intolerance]
    
    init() {
        let recipes = Recipes.getRecipes()
        var intolerances: [Recipe.Intolerance] = []
        
        for recipe in recipes {
            for intolerance in recipe.intolerances {
                if !intolerances.contains(where: {$0.type == intolerance.type}) {
                    intolerances.append(intolerance)
                }
            }
        }
        
        self.intolerances = intolerances.sorted(by: {$0.type < $1.type})
    }
}
