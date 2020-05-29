//
//  ShoppingListView.swift
//  Rezepte
//
//  Created by Daniel Bedrich on 13.02.20.
//  Copyright © 2020 Daniel Bedrich. All rights reserved.
//

import SwiftUI

struct ShoppingListView: View {
    @ObservedObject var viewModel = ShoppingListViewController()
    
    var body: some View {
        NavigationView{
            List {
                ForEach(viewModel.items, id: \.id) { item in
                    Item(item: item)
                        .onTapGesture {
                            self.viewModel.checkItem(item)
                        }
                }
                .onDelete(perform: { index in
                    self.viewModel.deleteItem(index)
                })
            }
            .navigationBarTitle("Einkaufsliste")
            .navigationBarItems(trailing:
                Button(action: {
                    self.viewModel.deleteAllItems()
                }, label: {
                    Image(systemName: "trash")
                        .imageScale(.large)
                }))
        }
        .onAppear(perform: {
            self.viewModel.loadItems()
        })
        .padding()
    }
}

struct Item: View {
    private var item: ShoppingIngredient
    private var name: String

    init(item: ShoppingIngredient) {
        if item.isChecked {
            name = "checkmark.circle"
        } else {
            name = "circle"
        }
        self.item = item
    }
    
    var body: some View {
        
        return HStack {
            Image(systemName: self.name)
                .font(.system(size: 25))
                .frame(width: 20)
                .foregroundColor(.accentColor)
            Text("\(item.amount) \(item.unit) \(item.name)")
        }
    }
}

struct ShoppingListView_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingListView()
    }
}
