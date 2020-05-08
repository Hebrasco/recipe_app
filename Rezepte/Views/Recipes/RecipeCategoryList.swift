//
//  RecipeCategoryList.swift
//  Rezepte
//
//  Created by Daniel Bedrich on 02.04.20.
//  Copyright © 2020 Daniel Bedrich. All rights reserved.
//

import SwiftUI

struct RecipeCategoryList: View {
    @State private var recipes: [Recipe] = []
    private let categoryTitle: String
    private let secondaryCategories: [RecipeCategory]
    private let isRecipeView: Bool
    
    init(category: RecipeCategory.Category) {
        self.categoryTitle = category.title
        
        switch category.type {
        case .recipes:
            self.secondaryCategories = [
                RecipeCategory(.breakfast, hasSubcategories: true),
                RecipeCategory(.lunch, hasSubcategories: true),
                RecipeCategory(.snack, hasSubcategories: true),
                RecipeCategory(.motto, hasSubcategories: true)]
        case .breakfast:
            self.secondaryCategories = [
                RecipeCategory(.fastfood),
                RecipeCategory(.bake),
                RecipeCategory(.breakfastFruits),
                RecipeCategory(.spread)]
        case .lunch:
            self.secondaryCategories = [
                RecipeCategory(.meat),
                RecipeCategory(.fish),
                RecipeCategory(.vegetarian),
                RecipeCategory(.pasta),
                RecipeCategory(.sweets),
                RecipeCategory(.soup)]
        case .motto:
            self.secondaryCategories = [
                RecipeCategory(.carnevall),
                RecipeCategory(.easter),
                RecipeCategory(.halloween),
                RecipeCategory(.xmas)]
        case .snack:
            self.secondaryCategories = [
                RecipeCategory(.snackFruits),
                RecipeCategory(.quark),
                RecipeCategory(.snackSweets),
                RecipeCategory(.hearty)]
        default:
            self.secondaryCategories = []
        }
        
        if category.type == .recipes {
            isRecipeView = true
        } else {
            isRecipeView = false
        }
        
        if isRecipeView {
            self.recipes = Recipes.getRecipes()
        } else {
            self.recipes = Recipes.getRecipes().filter{$0.primaryCategory.contains(category.title)}
        }
    }
    
    var body: some View {
        List {
            ForEach(secondaryCategories, id: \.id) {$0}
            ForEach(recipes, id: \.id) { recipe in
                RecipeCard(recipe, with: .Navigation)
            }
        }
        .onAppear(perform: {
            if self.isRecipeView {
                self.recipes = Recipes.getRecipes()
            } else {
                self.recipes = Recipes.getRecipes().filter{$0.primaryCategory.contains(self.categoryTitle)}
            }
        })
        .navigationBarTitle(categoryTitle)
    }
}

struct RecipeCategoryList_Previews: PreviewProvider {
    static var previews: some View {
        let category = RecipeCategory.Category(.breakfast)
        
        return RecipeCategoryList(category: category)
    }
}
