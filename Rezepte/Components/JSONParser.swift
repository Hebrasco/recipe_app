//
//  JSONParser.swift
//  Rezepte
//
//  Created by Daniel Bedrich on 19.02.20.
//  Copyright © 2020 Daniel Bedrich. All rights reserved.
//

import Foundation

class JSONParser {    
    func parse() -> [Recipe] {
        let fileName = "Recipes"
        let fileType = "json"
        
        guard let path = Bundle.main.path(forResource: fileName, ofType: fileType) else {
            print("File (\(fileName).\(fileType)) not found!")
            return []
        }
            
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: [])
            guard let jsonArray = jsonResult as? [[String: Any]] else { return [] }
            
            var recipies: [Recipe] = []
            
            for jsonObject in jsonArray {
                guard var image = jsonObject["Bild"] as? String else { break }
                guard let title = jsonObject["Rezeptname"] as? String else { break }
                let ingredients = getIngredients(recipe: jsonObject)
                let intolerances = getIntolerances(recipe: jsonObject)
                guard let category = jsonObject["Hauptkategorie"] as? String else { break }
                guard let tags = jsonObject["tags"] as? String else { break }
                guard let time = jsonObject["Zubereitungszeit"] as? Int else { break }
                let difficulty = getDifficulty(recipe: jsonObject["Schwierigkeitsgrad"] as! String)
                guard let preparation = jsonObject["Zubereitung"] as? String else { break }
                guard let tips = jsonObject["Tipps"] as? String else { break }
                guard let source = jsonObject["Link, Quelle"] as? String else { break }
                
                image = String(image.dropLast(4))
                
                let recipe = Recipe(image: image,
                                    title: title,
                                    ingredients: ingredients,
                                    intolerances: intolerances!,
                                    category: category,
                                    tags: tags,
                                    time: time,
                                    difficulty: difficulty,
                                    preparation: preparation,
                                    tips: tips,
                                    source: source)
                
                recipies.append(recipe)
            }
            return recipies
        } catch {
            print("Error while parsing JSON data. File: (\(fileName).\(fileType))")
        }
        return []
    }
    
    func getIngredients(recipe: [String: Any]) -> Recipe.Ingredients {
        var ingredients: [String] = []
        var ingredientsAmount: [String] = []
        var count = 1
        
        while count != 0 {
            guard let ingredient = recipe["Zutat \(count)"] as? String else { break }
            guard let ingredientAmount = recipe["Menge \(count)"] as? String else { break }
            
            ingredients.append(ingredient)
            ingredientsAmount.append(ingredientAmount)
            
            count += 1
        }
        
        return Recipe.Ingredients(type: ingredients, amount: ingredientsAmount)
    }
    
    func getIntolerances(recipe: [String: Any]) -> [Substring]? {
        guard let ingredients = recipe["Inhalt"] as? String else { return nil }
        
        return ingredients.split(separator: ",")
    }
    
    func getDifficulty(recipe: String) -> Recipe.Difficulty {
        switch recipe {
        case "einfach":
            return Recipe.Difficulty.easy
        case "mittel":
            return Recipe.Difficulty.medium
        case "schwer":
            return Recipe.Difficulty.hard
        default:
            return Recipe.Difficulty.easy
        }
    }
}
