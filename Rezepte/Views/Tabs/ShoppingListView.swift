//
//  ShoppingListView.swift
//  Rezepte
//
//  Created by Daniel Bedrich on 13.02.20.
//  Copyright © 2020 Daniel Bedrich. All rights reserved.
//

import SwiftUI

struct ShoppingListView: View {
    @ObservedObject var viewModel = ShoppingListViewModel()
    
    var body: some View {
        Text("Einkaufsliste")
    }
}

struct ShoppingListView_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingListView()
    }
}
