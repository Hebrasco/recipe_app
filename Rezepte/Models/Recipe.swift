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
    let id: Int
    let image: String
    let title: String
    var ingredients: [Ingredient]
    let intolerances: [Intolerance]
    let primaryCategory: String
    let secondaryCategory: String
    let tags: String
    let time: Int
    let difficulty: Difficulty
    let preparation: [String]
    let tips: String
    let source: String
    
    enum Difficulty: String {
        case defaultCase = "round_placeholder"
        case easy = "Einfach"
        case medium = "Mittel"
        case hard = "Schwer"
    }
    
    enum IntolerancesImages: String {
        case defaultCase = "round_placeholder"
        case vegetarian = "vegetarian"
        case nuts = "nuts"
        case halal = "halal"
        case vegan = "vegan"
        case lactose = "lactose_free"
        case gluten = "gluten"
        case wheat  = "wheat"
    }
    
    struct Ingredient {
        let id = UUID()
        let type: String
        var amount: String
        let baseAmount: String
        let unit: String
        
        init(type: String, amount: String, unit: String) {
            self.type = type
            self.amount = amount
            self.baseAmount = amount
            self.unit = unit
        }
    }
    
    struct Intolerance {
        let id = UUID()
        let type: String
        let image: IntolerancesImages
    }
}
