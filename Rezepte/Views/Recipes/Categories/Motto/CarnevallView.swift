//
//  CarnevallView.swift
//  Rezepte
//
//  Created by Daniel Bedrich on 20.02.20.
//  Copyright © 2020 Daniel Bedrich. All rights reserved.
//

import SwiftUI

struct CarnevallView: View {
    
    let recipies: [Recipe]
    
    init() {
        let jsonParser = JSONParser()
        recipies = jsonParser.parseRecipes()
    }
    
    var body: some View {
        List {
            ForEach(recipies.indices, id: \.self) { index in
                RecipeCard(recipe: self.recipies[index])
            }
        }
        .navigationBarTitle("Fasching")
    }
}

struct CarnevallView_Previews: PreviewProvider {
    static var previews: some View {
        CarnevallView()
    }
}
