//
//  FilterViewModel.swift
//  Rezepte
//
//  Created by Daniel Bedrich on 30.03.20.
//  Copyright © 2020 Daniel Bedrich. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import SwiftUI

class FilterViewModel: ObservableObject {
    @Published var filters: [Filter]
    let context: NSManagedObjectContext
    
    init() {
        func getFilters() -> [Filter] {
            var filters: [Filter] = []
            let recipes = Recipes.getRecipes()
            
            for recipe in recipes {
                for intolerance in recipe.intolerances {
                    if !filters.contains(where: {$0.intolerance.type == intolerance.type}) {
                        var isFilterActive = false
                        let isActive: Binding<Bool> = .init(get: {
                            isFilterActive
                        }, set: {
                            isFilterActive = $0
                        })
                        filters.append(Filter(intolerance: intolerance,
                                              isActive: isActive))
                    }
                }
            }
            
            return filters.sorted(by: {$0.intolerance.type < $1.intolerance.type})
        }
        
        func loadSavedFilters() {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FilterEntity")
            request.returnsObjectsAsFaults = false
            
            do {
                let items = try context.fetch(request)
                
                if items.count > 0 {
                    for item in items as! [NSManagedObject] {
                        let name = item.value(forKey: "name") as! String
                        let isActive = item.value(forKey: "isActive") as! Bool
                                                
                        for filter in filters.filter({$0.intolerance.type == name}) {
                            filter.isActive.wrappedValue = isActive
                        }
                    }
                }
            } catch {
                print("Error while getting active filters from CoreData")
            }
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.context = appDelegate.persistentContainer.viewContext
        
        self.filters = getFilters()
        loadSavedFilters()
    }
    
    func saveFilters() {
        for filter in filters {
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FilterEntity")
            request.returnsObjectsAsFaults = false
            
            do {
                var hasUpdatedFlag = false
                let items = try context.fetch(request)
                
                for item in items as! [NSManagedObject] {
                    let name = item.value(forKey: "name") as! String
                    let isActive = item.value(forKey: "isActive") as! Bool
                    
                    if name == filter.intolerance.type && isActive != filter.isActive.wrappedValue {
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
    
    func saveFilterToCoreData(_ filter: Filter) {
        print("saving...", filter.intolerance.type, "with", filter.isActive.wrappedValue)
        
        let filterEntity = FilterEntity(context: context)
        filterEntity.name = filter.intolerance.type
        filterEntity.isActive = filter.isActive.wrappedValue
    }
    
    func recipeContainsActiveFilterIntolerance(_ recipe: Recipe) -> Bool {
        var activeFilters: [Filter] = []
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FilterEntity")
        request.returnsObjectsAsFaults = false
        
        do {
            let items = try context.fetch(request)
            
            if items.count > 0 {
                for item in items as! [NSManagedObject] {
                    let name = item.value(forKey: "name") as! String
                    let isActive = item.value(forKey: "isActive") as! Bool
                    
                    if isActive {
                        for filter in filters.filter({$0.intolerance.type == name}) {
                            activeFilters.append(filter)
                        }
                    }
                }
            }
        } catch {
            print("Error while getting active filters from CoreData")
        }
        
        for activeFilter in activeFilters {
            for intolerance in recipe.intolerances {
                if intolerance.type == activeFilter.intolerance.type {
                    return true
                }
            }
            return recipe.intolerances.contains(where: {$0.type == activeFilter.intolerance.type})
        }
        return true
    }
    
    struct Filter {
        let id = UUID()
        let intolerance: Recipe.Intolerance
        var isActive: Binding<Bool>
    }
}
