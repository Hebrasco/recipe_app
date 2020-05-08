//
//  RecipePlanViewController.swift
//  Rezepte
//
//  Created by Daniel Bedrich on 13.02.20.
//  Copyright © 2020 Daniel Bedrich. All rights reserved.
//

import Foundation
import UIKit
import CoreData

final class RecipePlanViewController: ObservableObject {
    @Published var mondayRecipes: [PlanRecipe] = []
    @Published var thuesdayRecipes: [PlanRecipe] = []
    @Published var wednesdayRecipes: [PlanRecipe] = []
    @Published var thursdayRecipes: [PlanRecipe] = []
    @Published var fridayRecipes: [PlanRecipe] = []
    var savedPlans: [SavedPlan] = []
    private var mondayRecipesManagedObj: [NSManagedObject] = []
    private var thuesdayRecipesManagedObj: [NSManagedObject] = []
    private var wednesdayRecipesManagedObj: [NSManagedObject] = []
    private var thursdayRecipesManagedObj: [NSManagedObject] = []
    private var fridayRecipesManagedObj: [NSManagedObject] = []
    private var selectedPlan: SavedPlan
    private let context: NSManagedObjectContext
    
    init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.context = appDelegate.persistentContainer.viewContext
        selectedPlan = SavedPlan(name: "", createdAt: "")
        
        loadPlans()
        loadRecipes(isInit: true)
    }
    
    func loadPlans() {
        let requestPlanDates = NSFetchRequest<NSFetchRequestResult>(entityName: "WeeklyPlans")
        requestPlanDates.returnsObjectsAsFaults = false
        
        savedPlans = []
        
        do {
            let items = try context.fetch(requestPlanDates)
            
            if items.count > 0 {
                for item in items as! [NSManagedObject] {
                    let createdAt = item.value(forKey: "createdAt") as! String
                    let name = item.value(forKey: "name") as! String
                    
                    savedPlans.append(SavedPlan(name: name, createdAt: createdAt))
                }
                selectedPlan = savedPlans[0]
            }
        } catch {
            print("Error while getting recipe plan dates from CoreData")
        }
    }
    
    func loadRecipes(isInit: Bool = false) {
        let requestPlanEntites = NSFetchRequest<NSFetchRequestResult>(entityName: "WeeklyPlanEntity")
        requestPlanEntites.returnsObjectsAsFaults = false

        let recipes = Recipes.getRecipes()
        
        removeLoadedRecipes()
        
        do {
            let items = try context.fetch(requestPlanEntites)
            
            if items.count > 0 {
                for item in items as! [NSManagedObject] {
                    let id = item.value(forKey: "recipeID") as! Int
                    let weekday = item.value(forKey: "weekday") as! Int
                    let mealType = item.value(forKey: "mealType") as! String
                    let savedName = item.value(forKey: "savedName") as? String
                    let recipe = recipes.filter{$0.id == id}

                    if isInit {
                        continue
                    }
                    
                    if savedName != nil {
                        if savedName != selectedPlan.name {
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
    
    func saveRecipePlan(name: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy hh:mm"
        
        let weeklyPlans = WeeklyPlans(context: context)
        weeklyPlans.id = UUID()
        weeklyPlans.createdAt = dateFormatter.string(from: Date())
        weeklyPlans.name = name
        
        let requestPlanEntities = NSFetchRequest<NSFetchRequestResult>(entityName: "WeeklyPlanEntity")
        requestPlanEntities.returnsObjectsAsFaults = false
        
        do {
            let items = try context.fetch(requestPlanEntities)
            
            if items.count > 0 {
                for item in items as! [NSManagedObject] {
                    let savedName = item.value(forKey: "savedName") as? String
                    
                    if savedName == nil {
                        item.setValue(name, forKey: "savedName")
                    }
                }
            }
        } catch {
            print("Error while getting recipe plan dates from CoreData")
        }
        
        try? context.save()
        
        loadPlans()
    }
    
    func loadRecipePlan(_ plan: SavedPlan) {
        selectedPlan = plan
        
        loadRecipes()
    }
    
    func deleteReciePlan(_ plan: SavedPlan) {
        let requestPlanEntities = NSFetchRequest<NSFetchRequestResult>(entityName: "WeeklyPlanEntity")
        requestPlanEntities.returnsObjectsAsFaults = false
        
        do {
            let items = try context.fetch(requestPlanEntities)
            
            if items.count > 0 {
                for item in items as! [NSManagedObject] {
                    let savedName = item.value(forKey: "savedName") as? String
                    
                    if savedName == plan.name {
                        context.delete(item)
                    }
                }
            }
        } catch {
            print("Error while getting recipe plan dates from CoreData")
        }
        
        let requestPlans = NSFetchRequest<NSFetchRequestResult>(entityName: "WeeklyPlans")
        requestPlans.returnsObjectsAsFaults = false
        
        do {
            let items = try context.fetch(requestPlans)
            
            if items.count > 0 {
                for item in items as! [NSManagedObject] {
                    let savedName = item.value(forKey: "name") as? String
                    
                    if savedName == plan.name {
                        context.delete(item)
                    }
                }
            }
        } catch {
            print("Error while getting recipe plan dates from CoreData")
        }
        
        try? context.save()
        
        loadPlans()
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
    
    func removeLoadedRecipes() {
        func deleteManagedObj(in array: [NSManagedObject]) {
            for managedObj in array {
                let name = managedObj.value(forKey: "savedName") as? String
                if name == nil {
                    context.delete(managedObj)
                }
            }
        }
        
        deleteManagedObj(in: mondayRecipesManagedObj)
        deleteManagedObj(in: thuesdayRecipesManagedObj)
        deleteManagedObj(in: wednesdayRecipesManagedObj)
        deleteManagedObj(in: thursdayRecipesManagedObj)
        deleteManagedObj(in: fridayRecipesManagedObj)
        
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
    
    enum SheetContent {
        case save
        case load
        case delete
    }
    
    struct SavedPlan {
        let id = UUID()
        let name: String
        let createdAt: String
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
