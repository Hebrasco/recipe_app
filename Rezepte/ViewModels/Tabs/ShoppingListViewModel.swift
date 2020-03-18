//
//  ShoppingListViewModel.swift
//  Rezepte
//
//  Created by Daniel Bedrich on 13.02.20.
//  Copyright © 2020 Daniel Bedrich. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ShoppingListViewModel: ObservableObject {
    @Published var items: [ShoppingIngredient] = []
    let context: NSManagedObjectContext
    
    init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
        loadItems()
    }
    
    func loadItems() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ShoppingListEntity")
        request.returnsObjectsAsFaults = false
        
        do {
            let items = try context.fetch(request)
            
            if items.count == 0 {
                self.items = []
            } else {
                for item in items as! [NSManagedObject] {
                    let id = item.value(forKey: "id") as! UUID
                    let type = item.value(forKey: "type") as! String
                    let amount = item.value(forKey: "amount") as! String
                    let unit = item.value(forKey: "unit") as! String
                    let isChecked = item.value(forKey: "isChecked") as! Bool
                    
                    self.items.append(ShoppingIngredient(id: id,
                                                           name: type,
                                                           amount: amount,
                                                           unit: unit,
                                                           isChecked: isChecked))
                }
            }
        } catch {
            print("Error while getting shoppingList from CoreData")
        }
    }
    
    func deleteAllItems() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ShoppingListEntity")
        request.returnsObjectsAsFaults = false
        
        do {
            let items = try context.fetch(request)
            
            for item in items as! [NSManagedObject] {
                context.delete(item)
            }
            try? context.save()
        } catch {
            print("Error while getting shoppingList from CoreData")
        }
        loadItems()
    }
}
