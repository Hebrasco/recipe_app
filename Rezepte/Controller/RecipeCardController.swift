//
//  RecipeCardController.swift
//  Rezepte
//
//  Created by Daniel Bedrich on 25.03.20.
//  Copyright © 2020 Daniel Bedrich. All rights reserved.
//

import Foundation
import UIKit
import CoreData

final class RecipeCardController: ObservableObject {
    private let context: NSManagedObjectContext
    
    init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.context = appDelegate.persistentContainer.viewContext
    }
    
    func addRecipeToWeeklyPlan(_ recipe: Recipe, weekday: RecipePlanViewController.WeekDays, mealType: RecipePlanViewController.MealType) {
        let weeklyPlanEntity = WeeklyPlanEntity(context: context)
        weeklyPlanEntity.recipeID = Int32(recipe.id)
        weeklyPlanEntity.weekday = weekday.rawValue
        weeklyPlanEntity.mealType = mealType.rawValue
        
        try? context.save()
    }
    
    enum PressAction {
        case Navigation
        case Button
    }
}
