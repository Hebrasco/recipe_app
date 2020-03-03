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
                let ingredients = parseIngredients(result: jsonObject)
                let intolerances = parseIntolerances(result: jsonObject["Inhalt"] as! String)
                let difficulty = parseDifficulty(result: jsonObject["Schwierigkeitsgrad"] as! String)
                let preparation = parsePreparation(result: jsonObject["Zubereitung"] as! String)
                let image = parseImage(result: jsonObject["Bild"] as! String)
                let tags = parseTags(result: jsonObject["tags"] as! String)
                let category = parseCategory(result: jsonObject["Hauptkategorie"] as! String)
                
                guard let title = jsonObject["Rezeptname"] as? String else { break }
                guard let time = jsonObject["Zubereitungszeit"] as? Int else { break }
                guard let tips = jsonObject["Tipps"] as? String else { break }
                guard let source = jsonObject["Link, Quelle"] as? String else { break }
                
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
                
                recipes.append(recipe)
            }
            self.recipes = recipes
        } catch {
            print("Error while parsing JSON data. File: (\(name).\(type))")
        }
    }
    
    private static func parseImage(result: String) -> String {
        if result == "" {
            return "placeholder"
        } else {
            return String(result.dropLast(4))
        }
    }
    
    private static func parseTags(result: String) -> String {
        let tagsResult = result.split(separator: ",").map{String($0)}
        var tags = ""
        
        for tag in tagsResult {
            tags += "#\(tag), "
        }
        
        return String(tags.dropLast(2))
    }

    private static func parseCategory(result: String) -> String {
        let categoryResult = result.split(separator: ",").map{String($0)}
        var categories = ""
        
        for category in categoryResult {
            categories += "\(category), "
        }
        
        return String(categories.dropLast(2))
    }
    
    private static func parsePreparation(result: String) -> [String] {
        return result.split(separator: "\n").map{String($0)}
    }
    
    private static func parseIngredients(result: [String: Any]) -> [Recipe.Ingredient] {
        var ingredients: [Recipe.Ingredient] = []
        var count = 1
        
        while count != 0 {
            guard let ingredient = result["Zutat \(count)"] as? String else { break }
            guard let ingredientAmount = result["Menge \(count)"] as? String else { break }
            
            if ingredient == ""{
                break
            }
            
            ingredients.append(Recipe.Ingredient(type: ingredient, amount: ingredientAmount))
            
            count += 1
        }
        
        return ingredients
    }
    
    private static func parseIntolerances(result: String) -> [Recipe.Intolerance]? {
        let intolerancesObjects = result.split(separator: ",")
        var intolerances: [Recipe.Intolerance] = []
        
        for intolerancesObject in intolerancesObjects {
            let intoleranceName = String(intolerancesObject)
            var image: Recipe.IntolerancesImages
            
            switch intoleranceName {
            case "Vegetarisch":
                image = .vegetarian
                break
            case "Nüsse":
                image = .nuts
                break
            case "Halal":
                image = .halal
                break
            case "Vegan":
                image = .vegan
                break
            case "Laktose":
                image = .lactose
                break
            case "Gluten":
                image = .gluten
                break
            case "Weizen":
                image = .wheat
                break
            default:
                image = .defaultCase
                break
            }
            
            let intolerance = Recipe.Intolerance(type: intoleranceName, image: image)
            intolerances.append(intolerance)
        }
        return intolerances
    }
    
    private static func parseDifficulty(result: String) -> Recipe.Difficulty {
        switch result {
        case "einfach":
            return Recipe.Difficulty.easy
        case "mittel":
            return Recipe.Difficulty.medium
        case "schwer":
            return Recipe.Difficulty.hard
        default:
            return Recipe.Difficulty.defaultCase
        }
    }
}
