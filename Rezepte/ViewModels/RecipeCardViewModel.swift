//
//  RecipeCardViewModel.swift
//  Rezepte
//
//  Created by Daniel Bedrich on 25.03.20.
//  Copyright © 2020 Daniel Bedrich. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class RecipeCardViewModel: ObservableObject {
    let context: NSManagedObjectContext
    
    init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.context = appDelegate.persistentContainer.viewContext
    }
    
    func addRecipeToWeeklyPlan(_ recipe: Recipe, weekday: WeekDays) {
        let weeklyPlanEntity = WeeklyPlanEntity(context: context)
        weeklyPlanEntity.recipe_id = Int32(recipe.id)
        weeklyPlanEntity.weekday = weekday.rawValue
        
        try? context.save()
    }
    
    enum PressAction {
        case Navigation
        case Button
    }
    
    enum WeekDays: Int16 {
        case monday = 0
        case thuesday = 1
        case wednesday = 2
        case thursday = 3
        case friday = 4
    }
}
