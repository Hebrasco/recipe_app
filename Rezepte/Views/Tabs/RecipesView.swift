//
//  RecipesView.swift
//  Rezepte
//
//  Created by Daniel Bedrich on 13.02.20.
//  Copyright © 2020 Daniel Bedrich. All rights reserved.
//

import SwiftUI

struct RecipesView: View {
    @ObservedObject var viewModel = RecipesViewModel()
    
    var body: some View {
        Text("Rezepte")
    }
}

struct RecipesView_Previews: PreviewProvider {
    static var previews: some View {
        RecipesView()
    }
}
