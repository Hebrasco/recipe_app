//
//  RecipeViewModel.swift
//  Rezepte
//
//  Created by Daniel Bedrich on 11.03.20.
//  Copyright © 2020 Daniel Bedrich. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class RecipeViewModel: ObservableObject {
    @Published var amountCount = 1
    @Published var recipe: Recipe
    @Published var isFavorite: Bool
    var ingredients: [Recipe.Ingredient]
    var favoriteObj: NSManagedObject?
    let context: NSManagedObjectContext
    
    init(recipe: Recipe) {
        func formatIngredients(_ recipe: Recipe) -> [Recipe.Ingredient]{
            var formattedIngredients = recipe.ingredients
            
            let formatter = NumberFormatter()
            formatter.locale = Locale.current
            formatter.numberStyle = .decimal
            
            var i = 0
            for ingredient in recipe.ingredients {
                let amount = Double(ingredient.amount) ?? 0.0
                let formattedAmount = formatter.string(from: NSNumber(value: amount)) ?? "Error"
                formattedIngredients[i].amount = formattedAmount
                i += 1
            }
            
            return formattedIngredients
        }
        
        func loadFavoriteObj() {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteEntity")
            request.returnsObjectsAsFaults = false
            do {
                let results = try context.fetch(request)
                for result in results as! [NSManagedObject] {
                    let favoriteID = result.value(forKey: "recipe_id") as! Int
                    if favoriteID == recipe.id {
                        favoriteObj = result
                    }
                }
            } catch {
                print("Error while getting favorites from CoreData")
            }
        }
        
        self.recipe = recipe
        self.ingredients = formatIngredients(recipe)
        
        self.isFavorite = recipe.isFavorite
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
        loadFavoriteObj()
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
    
    func addToFavorites() {
        if !isFavorite {
            isFavorite = true
            recipe.isFavorite = isFavorite
            
            let favoriteEntity = FavoriteEntity(context: context)
            favoriteEntity.recipe_id = Int32(recipe.id)
            
            try? context.save()
        }
    }
    
    func deleteFromFavorites() {
        if isFavorite {
            isFavorite = false
            recipe.isFavorite = isFavorite
            
            if favoriteObj != nil {
                context.delete(favoriteObj!)
                try? context.save()
            }
        }
    }
}
