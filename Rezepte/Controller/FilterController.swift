//
//  FilterController.swift
//  Rezepte
//
//  Created by Daniel Bedrich on 30.03.20.
//  Copyright © 2020 Daniel Bedrich. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import SwiftUI

final class FilterController: ObservableObject {
    private let context: NSManagedObjectContext
    
    init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.context = appDelegate.persistentContainer.viewContext
    }
    
    func loadFilters() -> [Filter] {
        var filters: [Filter] = []
        let recipes = Recipes.getRecipes()
        
        
        print("loading filters...")
        
        for recipe in recipes {
            for intolerance in recipe.intolerances {
                if !filters.contains(where: {$0.intolerance.type == intolerance.type}) {
                    let isActive: Binding<Bool> = getIsActiveBinding(bool: isFilterSavedAndActive(intolerance.type))
                    
                    filters.append(Filter(intolerance: intolerance,
                                          isActive: isActive))
                }
            }
        }
        
        return filters.sorted(by: {$0.intolerance.type < $1.intolerance.type})
    }
    
    private func isFilterSavedAndActive(_ filterName: String) -> Bool {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FilterEntity")
        request.returnsObjectsAsFaults = false
        
        do {
            let items = try context.fetch(request)
            
            if items.count > 0 {
                for item in items as! [NSManagedObject] {
                    let name = item.value(forKey: "name") as! String
                    let isActive = item.value(forKey: "isActive") as! Bool
                      
                    if filterName == name {
                        return isActive
                    }
                }
            }
        } catch {
            print("Error while getting active filters from CoreData")
        }
        return false
    }
    
    private func getIsActiveBinding(bool: Bool) -> Binding<Bool> {
        var isActive = bool
        return .init(get: {
            isActive
        }, set: {
            isActive = $0
        })
    }
    
    func saveFilters(_ filters: [Filter]) {
        for filter in filters {
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FilterEntity")
            request.returnsObjectsAsFaults = false
            
            do {
                var hasUpdatedFlag = false
                let items = try context.fetch(request)
                
                for item in items as! [NSManagedObject] {
                    let name = item.value(forKey: "name") as! String
                    
                    if name == filter.intolerance.type {
                        print("updating...", filter.intolerance.type, "to", filter.isActive.wrappedValue)
                        item.setValue(filter.isActive.wrappedValue, forKey: "isActive")
                        hasUpdatedFlag = true
                    }
                }
                if !hasUpdatedFlag {
                    saveFilterToCoreData(filter)
                }
            } catch {
                print("Error while getting filters from CoreData")
            }
            
            try? context.save()
        }
    }
    
    private func saveFilterToCoreData(_ filter: Filter) {
        print("saving...", filter.intolerance.type, "with", filter.isActive.wrappedValue)
        
        let filterEntity = FilterEntity(context: context)
        filterEntity.name = filter.intolerance.type
        filterEntity.isActive = filter.isActive.wrappedValue
    }
    
    func recipeContainsActiveFilterIntolerance(_ recipe: Recipe, filters: [Filter]) -> Bool {
        let activeFilters = filters.filter{$0.isActive.wrappedValue}
        var equalIntolances = 0
        
        for activeFilter in activeFilters {
            for intolerance in recipe.intolerances {
                if intolerance.type == activeFilter.intolerance.type {
                    equalIntolances += 1
                }
            }
        }

        return activeFilters.count == equalIntolances
    }
    
    struct Filter {
        let id = UUID()
        let intolerance: Recipe.Intolerance
        var isActive: Binding<Bool>
    }
}
