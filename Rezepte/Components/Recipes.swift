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
            
            self.recipes = parseRecipes(jsonArray)
        } catch {
            print("Error while parsing JSON data. File: (\(name).\(type))")
        }
    }
    
    private static func parseRecipes(_ jsonArray: [[String: Any]]) -> [Recipe] {
        var recipes: [Recipe] = []
        
        for jsonObject in jsonArray {
            let ingredients = parseIngredients(jsonObject)
            let intolerances = parseIntolerances(jsonObject["Inhalt"] as! String)
            let difficulty = parseDifficulty(jsonObject["Schwierigkeitsgrad"] as! String)
            let preparation = parsePreparation(jsonObject["Zubereitung"] as! String)
            let image = parseImage(jsonObject["Bild"] as! String)
            let tags = parseTags(jsonObject["tags"] as! String)
            let primaryCategory = parseCategory(jsonObject["Hauptkategorie"] as! String)
            let secondaryCategory = parseCategory(jsonObject["Unterkategorie 1"] as! String)
            
            guard let id = jsonObject["Rezept-ID"] as? Int else { break }
            guard let title = jsonObject["Rezeptname"] as? String else { break }
            guard let time = jsonObject["Zubereitungszeit"] as? Int else { break }
            guard let tips = jsonObject["Tipps"] as? String else { break }
            guard let source = jsonObject["Link, Quelle"] as? String else { break }
            
            let recipe = Recipe(id: id,
                                image: image,
                                title: title,
                                ingredients: ingredients,
                                intolerances: intolerances!,
                                primaryCategory: primaryCategory,
                                secondaryCategory: secondaryCategory,
                                tags: tags,
                                time: time,
                                difficulty: difficulty,
                                preparation: preparation,
                                tips: tips,
                                source: source)
            
            recipes.append(recipe)
        }
        return recipes
    }
    
    private static func parseImage(_ result: String) -> String {
        if result == "" {
            return "placeholder"
        } else {
            return String(result.dropLast(4))
        }
    }
    
    private static func parseTags(_ result: String) -> String {
        let tagsResult = result.split(separator: ",").map{String($0)}
        var tags = ""
        
        for tag in tagsResult {
            tags += "#\(tag), "
        }
        
        return String(tags.dropLast(2))
    }

    private static func parseCategory(_ result: String) -> String {
        let categoryResult = result.split(separator: ",").map{String($0)}
        var categories = ""
        
        for category in categoryResult {
            categories += "\(category), "
        }
        
        return String(categories.dropLast(2))
    }
    
    private static func parsePreparation(_ result: String) -> [String] {
        return result.split(separator: "\n").map{String($0)}
    }
    
    private static func parseIngredients(_ result: [String: Any]) -> [Recipe.Ingredient] {
        var ingredients: [Recipe.Ingredient] = []
        var count = 1
        
        while count != 0 {
            guard let ingredient = result["Zutat \(count)"] as? String else { break }
            guard let ingredientAmountObj = result["Menge \(count)"] as? String else { break }
            
            count += 1
            
            if ingredient == ""{
                break
            }
            
            let tempObj = ingredientAmountObj.split(separator: " ")
            let ingredientUnit: String
            let ingredientAmount: String
            
            if tempObj.count >= 2 {
                ingredientAmount = String(tempObj[0])
                ingredientUnit = String(tempObj[1])
            } else if tempObj.count == 1 {
                ingredientAmount = String(tempObj[0])
                ingredientUnit = ""
            } else {
                ingredientAmount = ""
                ingredientUnit = ""
            }
            
            ingredients.append(Recipe.Ingredient(type: ingredient, amount: ingredientAmount, unit: ingredientUnit))
        }
        
        return ingredients
    }
    
    private static func parseIntolerances(_ result: String) -> [Recipe.Intolerance]? {
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
    
    private static func parseDifficulty(_ result: String) -> Recipe.Difficulty {
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
