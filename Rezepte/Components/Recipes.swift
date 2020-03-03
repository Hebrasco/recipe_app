//
//  Recipes.swift
//  Rezepte
//
//  Created by Daniel Bedrich on 19.02.20.
//  Copyright © 2020 Daniel Bedrich. All rights reserved.
//

import Foundation

class Recipes {
    static var recipes: [Recipe] = []
    
    static func parse() {
        let name = "Recipes"
        let type = "json"
        
        guard let path = Bundle.main.path(forResource: name, ofType: type) else {
            print("File (\(name).\(type)) not found!")
            return
        }
            
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: [])
            guard let jsonArray = jsonResult as? [[String: Any]] else { return }
            
            var recipes: [Recipe] = []
            
            for jsonObject in jsonArray {
                let ingredients = getIngredients(recipe: jsonObject)
                let intolerances = getIntolerances(recipe: jsonObject)
                let difficulty = getDifficulty(recipe: jsonObject["Schwierigkeitsgrad"] as! String)
                
                guard let title = jsonObject["Rezeptname"] as? String else { break }
                guard let category = jsonObject["Hauptkategorie"] as? String else { break }
                guard let tags = jsonObject["tags"] as? String else { break }
                guard let time = jsonObject["Zubereitungszeit"] as? Int else { break }
                guard let preparation = jsonObject["Zubereitung"] as? String else { break }
                guard let tips = jsonObject["Tipps"] as? String else { break }
                guard let source = jsonObject["Link, Quelle"] as? String else { break }
                guard var image = jsonObject["Bild"] as? String else { break }
                
                if image == "" {
                    image = "placeholder"
                } else {
                    image = String(image.dropLast(4))
                }
                
                let preparationArray = preparation.split(separator: "\n")
                                                  .map{String($0)}
                
                let recipe = Recipe(image: image,
                                    title: title,
                                    ingredients: ingredients,
                                    intolerances: intolerances!,
                                    category: category,
                                    tags: tags,
                                    time: time,
                                    difficulty: difficulty,
                                    preparation: preparationArray,
                                    tips: tips,
                                    source: source)
                
                recipes.append(recipe)
            }
            self.recipes = recipes
        } catch {
            print("Error while parsing JSON data. File: (\(name).\(type))")
        }
    }
    
    private static func getIngredients(recipe: [String: Any]) -> [Recipe.Ingredient] {
        var ingredients: [Recipe.Ingredient] = []
        var count = 1
        
        while count != 0 {
            guard let ingredient = recipe["Zutat \(count)"] as? String else { break }
            guard let ingredientAmount = recipe["Menge \(count)"] as? String else { break }
            
            if ingredient == ""{
                break
            }
            
            ingredients.append(Recipe.Ingredient(type: ingredient, amount: ingredientAmount))
            
            count += 1
        }
        
        return ingredients
    }
    
    private static func getIntolerances(recipe: [String: Any]) -> [Recipe.Intolerance]? {
        guard let intolerancesResult = recipe["Inhalt"] as? String else { return nil }
        let intolerancesObjects = intolerancesResult.split(separator: ",")
        var intolerances: [Recipe.Intolerance] = []
        
        for intolerancesObject in intolerancesObjects {
            let intolerance = String(intolerancesObject)
            
            switch intolerance {
            case "Vegetarisch":
                intolerances.append(Recipe.Intolerance(type: intolerance, image: .vegetarian))
                break
            case "Nüsse":
                intolerances.append(Recipe.Intolerance(type: intolerance, image: .nuts))
                break
            case "Halal":
                intolerances.append(Recipe.Intolerance(type: intolerance, image: .halal))
                break
            case "Vegan":
                intolerances.append(Recipe.Intolerance(type: intolerance, image: .vegan))
                break
            case "Laktose":
                intolerances.append(Recipe.Intolerance(type: intolerance, image: .lactose))
                break
            case "Gluten":
                intolerances.append(Recipe.Intolerance(type: intolerance, image: .gluten))
                break
            case "Weizen":
                intolerances.append(Recipe.Intolerance(type: intolerance, image: .wheat))
                break
            default:
                break
            }
        }
        return intolerances
    }
    
    private static func getDifficulty(recipe: String) -> Recipe.Difficulty {
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
