//
//  RecipeViewModel.swift
//  Rezepte
//
//  Created by Daniel Bedrich on 11.03.20.
//  Copyright © 2020 Daniel Bedrich. All rights reserved.
//

import Foundation

class RecipeViewModel: ObservableObject {
    @Published var amountCount = 1
    var ingredients: [Recipe.Ingredient]
    
    init(ingredients: [Recipe.Ingredient]) {
        var formattedIngredients = ingredients
        
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .decimal
        
        var i = 0
        for ingredient in ingredients {
            let amount = Double(ingredient.amount) ?? 0.0
            let formattedAmount = formatter.string(from: NSNumber(value: amount)) ?? "Error"
            formattedIngredients[i].amount = formattedAmount
            i += 1
        }
        
        self.ingredients = formattedIngredients
    }
    
    func increaseAmount(by amount: Int) {
        if amountCount + amount < 100 {
            amountCount += amount
            recalculateIngredientsAmount()
        }
    }
    
    func decreaseAmount(by amount: Int) {
        if amountCount - amount > 0 {
            amountCount -= amount
            recalculateIngredientsAmount()
        }
    }
    
    private func recalculateIngredientsAmount() {
        func calculateWithAmountContainsDash(ingredient: Recipe.Ingredient) -> String {
            var amountArray: [Substring] = []
            
            let formatter = NumberFormatter()
            formatter.locale = Locale.current
            formatter.numberStyle = .decimal
            
            amountArray = ingredient.baseAmount.split(separator: "-")
            if amountArray.count > 1 {
                var n = 0
                for amount in amountArray {
                    amountArray[n] = Substring(String(Double(amount) ?? 0 * Double(amountCount)))
                    n += 1
                }
            }

            let amountOne = Double(amountArray[0]) ?? 0.0
            let amountTwo = Double(amountArray[1]) ?? 0.0
            if amountOne == 0 || amountTwo == 0 {
                return ""
            } else {
                let firstAmount = NSNumber(value: amountOne * Double(amountCount))
                let secondAmount = NSNumber(value: amountTwo * Double(amountCount))
                return "\(formatter.string(from: firstAmount) ?? "Error")-\(formatter.string(from: secondAmount) ?? "Error")"
            }
        }
        
        func calculateNormalNumbers(ingredient: Recipe.Ingredient) -> String {
            let baseAmount = Double(ingredient.baseAmount) ?? 0.0
            
            let formatter = NumberFormatter()
            formatter.locale = Locale.current
            formatter.numberStyle = .decimal
            
            if baseAmount == 0 {
                return ""
            } else {
                let amount = NSNumber(value: baseAmount * Double(amountCount))
                return formatter.string(from: amount) ?? "Error"
            }
        }
        
        var i = 0
        for ingredient in ingredients {
            var newAmount: String
            
            if ingredient.baseAmount.contains("-") {
                newAmount = calculateWithAmountContainsDash(ingredient: ingredient)
            } else {
                newAmount = calculateNormalNumbers(ingredient: ingredient)
            }
            
            ingredients[i].amount = newAmount
            i += 1
            
        }
    }
}
