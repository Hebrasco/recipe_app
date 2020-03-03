//
//  Recipe.swift
//  Rezepte
//
//  Created by Daniel Bedrich on 19.02.20.
//  Copyright © 2020 Daniel Bedrich. All rights reserved.
//

import Foundation
import SwiftUI

struct Recipe {
    let image: String
    let title: String
    let ingredients: [Ingredient]
    let intolerances: [Intolerance]
    let category: String
    let tags: String
    let time: Int
    let difficulty: Difficulty
    let preparation: [String]
    let tips: String
    let source: String
    
    enum Difficulty: String {
        case defaultCase = "difficulty_placeholder"
        case easy = "Einfach"
        case medium = "Mittel"
        case hard = "Schwer"
    }
    
    enum IntolerancesImages: String {
        case defaultCase = "intolerance_placeholder"
        case vegetarian = "vegetarian"
        case nuts = "nuts"
        case halal = "halal"
        case vegan = "vegan"
        case lactose = "lactose_free"
        case gluten = "gluten"
        case wheat  = "wheat"
    }
    
    struct Ingredient {
        let type: String
        let amount: String
    }
    
    struct Intolerance {
        let type: String
        let image: IntolerancesImages
    }
}
