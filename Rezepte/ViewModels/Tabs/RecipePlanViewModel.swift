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
    @Published var mondayRecipes: [PlanRecipe] = []
    @Published var thuesdayRecipes: [PlanRecipe] = []
    @Published var wednesdayRecipes: [PlanRecipe] = []
    @Published var thursdayRecipes: [PlanRecipe] = []
    @Published var fridayRecipes: [PlanRecipe] = []
    var mondayRecipesManagedObj: [NSManagedObject] = []
    var thuesdayRecipesManagedObj: [NSManagedObject] = []
    var wednesdayRecipesManagedObj: [NSManagedObject] = []
    var thursdayRecipesManagedObj: [NSManagedObject] = []
    var fridayRecipesManagedObj: [NSManagedObject] = []
    var savedPlanDates: [Date] = []
    var selectedPlanDate: Date
    let context: NSManagedObjectContext
    
    init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.context = appDelegate.persistentContainer.viewContext
        selectedPlanDate = Calendar.current.startOfDay(for: Date())
        
        loadDates()
        loadRecipes(isInit: true)
    }
    
    func loadDates() {
        let requestPlanDates = NSFetchRequest<NSFetchRequestResult>(entityName: "WeeklyPlanDates")
        requestPlanDates.returnsObjectsAsFaults = false
        
        do {
            let items = try context.fetch(requestPlanDates)
            
            if items.count > 0 {
                for item in items as! [NSManagedObject] {
                    let date = item.value(forKey: "date") as! Date
                    
                    savedPlanDates.append(date)
                }
                selectedPlanDate = Calendar.current.startOfDay(for: savedPlanDates[0])
            }
        } catch {
            print("Error while getting recipe plan dates from CoreData")
        }
    }
    
    func loadRecipes(isInit: Bool = false) {
        let requestPlanEntites = NSFetchRequest<NSFetchRequestResult>(entityName: "WeeklyPlanEntity")
        requestPlanEntites.returnsObjectsAsFaults = false

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
            let items = try context.fetch(requestPlanEntites)
            
            print(items.count)
            
            if items.count > 0 {
                for item in items as! [NSManagedObject] {
                    let id = item.value(forKey: "recipeID") as! Int
                    let weekday = item.value(forKey: "weekday") as! Int
                    let mealType = item.value(forKey: "mealType") as! String
                    let savedDate = item.value(forKey: "savedDate") as? Date
                    let recipe = recipes.filter{$0.id == id}

                    if isInit {
                        if savedDate != nil {
                            continue
                        }
                    }
                    
                    let planRecipe = PlanRecipe(recipe[0], withMealType: mealType)
                    
                    switch weekday {
                    case 0:
                        mondayRecipes.append(planRecipe)
                        mondayRecipesManagedObj.append(item)
                        break
                    case 1:
                        thuesdayRecipes.append(planRecipe)
                        thuesdayRecipesManagedObj.append(item)
                        break
                    case 2:
                        wednesdayRecipes.append(planRecipe)
                        wednesdayRecipesManagedObj.append(item)
                        break
                    case 3:
                        thursdayRecipes.append(planRecipe)
                        thursdayRecipesManagedObj.append(item)
                        break
                    case 4:
                        fridayRecipes.append(planRecipe)
                        fridayRecipesManagedObj.append(item)
                        break
                    default:
                        break
                    }
                }
            }
        } catch {
            print("Error while getting recipe plan from CoreData")
        }
    }
    
    func saveRecipePlan() {
        let calendar = Calendar.current
        
        let requestPlanDates = NSFetchRequest<NSFetchRequestResult>(entityName: "WeeklyPlanDates")
        requestPlanDates.returnsObjectsAsFaults = false
        
        do {
            let items = try context.fetch(requestPlanDates)
            
            if items.count > 0 {
                for item in items as! [NSManagedObject] {
                    let date = item.value(forKey: "date") as! Date
                    
                    print(item)
                    
                    if !Calendar.current.isDateInToday(date) {
                        let weeklyPlanDates = WeeklyPlanDates(context: context)
                        weeklyPlanDates.id = UUID()
                        weeklyPlanDates.date = calendar.startOfDay(for: Date())
                    }
                }
            } else {
                let weeklyPlanDates = WeeklyPlanDates(context: context)
                weeklyPlanDates.id = UUID()
                weeklyPlanDates.date = calendar.startOfDay(for: Date())
            }
        } catch {
            print("Error while getting recipe plan dates from CoreData")
        }
        
        let requestPlanEntities = NSFetchRequest<NSFetchRequestResult>(entityName: "WeeklyPlanEntity")
        requestPlanEntities.returnsObjectsAsFaults = false
        
        do {
            let items = try context.fetch(requestPlanEntities)
            
            
            
            if items.count > 0 {
                for item in items as! [NSManagedObject] {
                    let date = item.value(forKey: "savedDate") as? Date
                    
                    print(item)
                    
                    if date == nil {
                        item.setValue(calendar.startOfDay(for: Date()), forKey: "savedDate")
                    }
                }
            }
            print("items:", items)
        } catch {
            print("Error while getting recipe plan dates from CoreData")
        }
        
        try? context.save()
    }
    
    func loadRecipePlan(withDate date: Date) {
        selectedPlanDate = Calendar.current.startOfDay(for: date)
        
        loadRecipes()
    }
    
    func deleteReciePlan() {
        
    }
    
    func removeRecipe(with indexSet: IndexSet, from weekday: WeekDays) {
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
        }

        try? context.save()
    }
    
    func removeAllRecipes() {
//        for managedObj in mondayRecipesManagedObj {
//            context.delete(managedObj)
//        }
//
//        for managedObj in thuesdayRecipesManagedObj {
//            context.delete(managedObj)
//        }
//
//        for managedObj in wednesdayRecipesManagedObj {
//            context.delete(managedObj)
//        }
//
//        for managedObj in thursdayRecipesManagedObj {
//            context.delete(managedObj)
//        }
//
//        for managedObj in fridayRecipesManagedObj {
//            context.delete(managedObj)
//        }
//
//        try? context.save()
        
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
    
    enum WeekDays: Int16 {
        case monday = 0
        case thuesday = 1
        case wednesday = 2
        case thursday = 3
        case friday = 4
    }
    
    enum MealType: String {
        case breakfast = "breakfast"
        case lunch = "lunch"
        case snack = "snack"
    }
    
    
    struct PlanRecipe {
        let id: UUID
        let recipe: Recipe
        let mealType: String
        
        init(_ recipe: Recipe, withMealType mealType: String) {
            self.id = UUID()
            self.recipe = recipe
            self.mealType = mealType
        }
    }
}
