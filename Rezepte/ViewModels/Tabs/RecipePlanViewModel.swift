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
    var mondayRecipesManagedObj: [NSManagedObject] = []
    var thuesdayRecipesManagedObj: [NSManagedObject] = []
    var wednesdayRecipesManagedObj: [NSManagedObject] = []
    var thursdayRecipesManagedObj: [NSManagedObject] = []
    var fridayRecipesManagedObj: [NSManagedObject] = []
    let context: NSManagedObjectContext
    
    init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.context = appDelegate.persistentContainer.viewContext
        
        loadRecipes()
    }
    
    func loadRecipes() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "WeeklyPlanEntity")
        request.returnsObjectsAsFaults = false

        let recipes = Recipes.getRecipes()
        
        self.mondayRecipes = []
        self.thuesdayRecipes = []
        self.wednesdayRecipes = []
        self.thursdayRecipes = []
        self.fridayRecipes = []
        
        self.mondayRecipesManagedObj = []
        self.thuesdayRecipesManagedObj = []
        self.wednesdayRecipesManagedObj = []
        self.thursdayRecipesManagedObj = []
        self.fridayRecipesManagedObj = []
        
        do {
            let items = try context.fetch(request)
            
            if items.count > 0 {
                for item in items as! [NSManagedObject] {
                    let id = item.value(forKey: "recipe_id") as! Int
                    let weekday = item.value(forKey: "weekday") as! Int
                    let recipe = recipes.filter{$0.id == id}
                    
                    switch weekday {
                    case 0:
                        mondayRecipes.append(recipe[0])
                        mondayRecipesManagedObj.append(item)
                        break
                    case 1:
                        thuesdayRecipes.append(recipe[0])
                        thuesdayRecipesManagedObj.append(item)
                        break
                    case 2:
                        wednesdayRecipes.append(recipe[0])
                        wednesdayRecipesManagedObj.append(item)
                        break
                    case 3:
                        thursdayRecipes.append(recipe[0])
                        thursdayRecipesManagedObj.append(item)
                        break
                    case 4:
                        fridayRecipes.append(recipe[0])
                        fridayRecipesManagedObj.append(item)
                        break
                    default:
                        break
                    }
                }
            }
        } catch {
            print("Error while getting reciple plan from CoreData")
        }
    }
    
    func removeRecipe(with indexSet: IndexSet, from weekday: RecipeCardViewModel.WeekDays) {
        switch weekday {
        case .monday:
            for index in indexSet {
                mondayRecipes.remove(at: index)
                context.delete(mondayRecipesManagedObj[index])
            }
            break
        case .thuesday:
            for index in indexSet {
                thuesdayRecipes.remove(at: index)
                context.delete(thuesdayRecipesManagedObj[index])
            }
            break
        case .wednesday:
            for index in indexSet {
                wednesdayRecipes.remove(at: index)
                context.delete(wednesdayRecipesManagedObj[index])
            }
            break
        case .thursday:
            for index in indexSet {
                thursdayRecipes.remove(at: index)
                context.delete(thursdayRecipesManagedObj[index])
            }
            break
        case .friday:
            for index in indexSet {
                fridayRecipes.remove(at: index)
                context.delete(fridayRecipesManagedObj[index])
            }
            break
        default:
            break
        }

        try? context.save()
    }
    
    func removeAllRecipes() {
        for managedObj in mondayRecipesManagedObj {
            context.delete(managedObj)
        }
        
        for managedObj in thuesdayRecipesManagedObj {
            context.delete(managedObj)
        }
        
        for managedObj in wednesdayRecipesManagedObj {
            context.delete(managedObj)
        }
        
        for managedObj in thursdayRecipesManagedObj {
            context.delete(managedObj)
        }
        
        for managedObj in fridayRecipesManagedObj {
            context.delete(managedObj)
        }
        
        try? context.save()
        
        self.mondayRecipes = []
        self.thuesdayRecipes = []
        self.wednesdayRecipes = []
        self.thursdayRecipes = []
        self.fridayRecipes = []
        
        self.mondayRecipesManagedObj = []
        self.thuesdayRecipesManagedObj = []
        self.wednesdayRecipesManagedObj = []
        self.thursdayRecipesManagedObj = []
        self.fridayRecipesManagedObj = []
    }
}
