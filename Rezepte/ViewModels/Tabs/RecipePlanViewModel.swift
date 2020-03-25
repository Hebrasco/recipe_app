//
//  RecipePlanViewModel.swift
//  Rezepte
//
//  Created by Daniel Bedrich on 13.02.20.
//  Copyright © 2020 Daniel Bedrich. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class RecipePlanViewModel: ObservableObject {
    @Published var mondayRecipes: [Recipe] = []
    @Published var thuesdayRecipes: [Recipe] = []
    @Published var wednesdayRecipes: [Recipe] = []
    @Published var thursdayRecipes: [Recipe] = []
    @Published var fridayRecipes: [Recipe] = []
    let context: NSManagedObjectContext
    
    init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.context = appDelegate.persistentContainer.viewContext
        
        leadRecipes()
    }
    
    func leadRecipes() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "WeeklyPlanEntity")
        request.returnsObjectsAsFaults = false
        

        let recipes = Recipes.getRecipes()
        
        self.mondayRecipes = []
        self.thuesdayRecipes = []
        self.wednesdayRecipes = []
        self.thursdayRecipes = []
        self.fridayRecipes = []
        
        do {
            let items = try context.fetch(request)
            
            if items.count > 0 {
                for item in items as! [NSManagedObject] {
                    let id = item.value(forKey: "recipe_id") as! Int
                    let weekday = item.value(forKey: "weekday") as! Int
                    let recipe = recipes.filter{$0.id == id}
                    
                    if weekday == 0 {
                        mondayRecipes.append(recipe[0])
                    } else if weekday == 1 {
                        thuesdayRecipes.append(recipe[0])
                    } else if weekday == 2 {
                        wednesdayRecipes.append(recipe[0])
                    } else if weekday == 3 {
                        thursdayRecipes.append(recipe[0])
                    } else if weekday == 4 {
                        fridayRecipes.append(recipe[0])
                    }
                }
            }
        } catch {
            print("Error while getting shoppingList from CoreData")
        }
    }
}
