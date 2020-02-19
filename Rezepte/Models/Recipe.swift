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
    let ingredients: [String]
    let intolerances: [String]
    let category: String
    let tags: String
    let time: Int
    let difficulty: Difficulty
    
    enum Difficulty: String {
        case easy = "Einfach"
        case medium = "Mittel"
        case hard = "Schwer"
    }
}
