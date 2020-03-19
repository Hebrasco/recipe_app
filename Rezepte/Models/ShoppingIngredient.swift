//
//  ShoppingIngredient.swift
//  Rezepte
//
//  Created by Daniel Bedrich on 05.03.20.
//  Copyright © 2020 Daniel Bedrich. All rights reserved.
//

import Foundation

struct ShoppingIngredient {
    let id: UUID
    let name: String
    let amount: String
    let unit: String
    var isChecked = false
}
