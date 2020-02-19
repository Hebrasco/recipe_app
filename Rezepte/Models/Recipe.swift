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
    let ingredients: Ingredients
    let intolerances: [Substring]
    let category: String
    let tags: String
    let time: Int
    let difficulty: Difficulty
    let preparation: String
    let tips: String
    let source: String
    
    enum Difficulty: String {
        case easy = "Einfach"
        case medium = "Mittel"
        case hard = "Schwer"
    }
    
    struct Ingredients {
        let type: [String]
        let amount: [String]
    }
}

