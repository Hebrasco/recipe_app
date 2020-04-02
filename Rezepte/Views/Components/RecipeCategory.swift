//
//  RecipeCategory.swift
//  Rezepte
//
//  Created by Daniel Bedrich on 18.02.20.
//  Copyright © 2020 Daniel Bedrich. All rights reserved.
//

import SwiftUI

struct RecipeCategory: View {
    let id = UUID()
    let category: Category
    let hasSubcategories: Bool
    
    init(_ category: Category.Categories, hasSubcategories: Bool = false) {
        self.category = Category(category)
        self.hasSubcategories = hasSubcategories
    }
    
    var body: some View {
        let destination: AnyView
        if hasSubcategories {
            destination = AnyView(RecipeCategoryList(category: category))
        } else {
            destination = AnyView(RecipeSearchBarList(categoryTitle: category.title))
        }
        
        return NavigationLink(
            destination: destination,
            label: {
                HStack {
                Image(category.image)
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.accentColor)
                Text(category.title)
                    .foregroundColor(.primary)
                }
            }
        )
    }
    
    struct Category {
        let type: Categories
        let title: String
        let image: String
        
        init(_ type: Categories) {
            self.type = type
            
            switch type {
            case .recipes:
                title = "Rezepte"
                image = ""
            case .breakfast:
                title = "Frühstück"
                image = "breakfast"
            case .fastfood:
                title = "Schnelle Rezepte"
                image = "fastfood"
            case .bake:
                title = "Backen"
                image = "bake"
            case .breakfastFruits:
                title = "Obst"
                image = "fruits"
            case .spread:
                title = "Aufstriche"
                image = "spread"
            case .lunch:
                title = "Mittagessen"
                image = "lunch"
            case .meat:
                title = "Fleisch"
                image = "meat"
            case .fish:
                title = "Fisch"
                image = "fish"
            case .vegetarian:
                title = "Vegetarisch"
                image = "vegetarian"
            case .pasta:
                title = "Pasta & Co"
                image = "pasta"
            case .sweets:
                title = "Süßes"
                image = "sweets"
            case .soup:
                title = "Suppen"
                image = "soup"
            case .motto:
                title = "Motto/Anlässe"
                image = "motto"
            case .carnevall:
                title = "Fasching"
                image = "carnevall"
            case .easter:
                title = "Ostern"
                image = "easter"
            case .halloween:
                title = "Halloween"
                image = "halloween"
            case .xmas:
                title = "Weihnachten"
                image = "xmas"
            case .snack:
                title = "Nachtisch/Snack"
                image = "snack"
            case .snackFruits:
                title = "Obst"
                image = "fruits"
            case .quark:
                title = "Quark & Co"
                image = "quark"
            case .snackSweets:
                title = "Süßes"
                image = "sweets"
            case .hearty:
                title = "Herzhaftes"
                image = "hearty"
            }
        }

        enum Categories {
            case recipes
            case breakfast,
                 fastfood,
                 bake,
                 breakfastFruits,
                 spread
            case lunch,
                 meat,
                 fish,
                 vegetarian,
                 pasta,
                 sweets,
                 soup
            case motto,
                 carnevall,
                 easter,
                 halloween,
                 xmas
            case snack,
                 snackFruits,
                 quark,
                 snackSweets,
                 hearty
        }
    }
}

struct RecipeCategory_Previews: PreviewProvider {
    static var previews: some View {
        RecipeCategory(.breakfast)
    }
}
