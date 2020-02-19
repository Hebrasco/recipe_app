//
//  MottoView.swift
//  Rezepte
//
//  Created by Daniel Bedrich on 18.02.20.
//  Copyright © 2020 Daniel Bedrich. All rights reserved.
//

import SwiftUI

struct MottoView: View {
    let recipies: [Recipe]
    
    init() {
        let jsonParser = JSONParser()
        recipies = jsonParser.parse()
    }
    
    var body: some View {
        List {
            Category(name: "Fasching",
                      image: "carnevall",
                      destination: AnyView(FastFoodView()))
            Category(name: "Ostern",
                      image: "easter",
                      destination: AnyView(BakeView()))
            Category(name: "Halloween",
                      image: "halloween",
                      destination: AnyView(FruitsView()))
            Category(name: "Weihnachten",
                      image: "xmas",
                      destination: AnyView(SpreadView()))
            ForEach(recipies.indices, id: \.self) { index in
                RecipeCard(recipe: self.recipies[index])
            }
        }
        .navigationBarTitle("Motto/Anlässe")
    }
}

struct MottoView_Previews: PreviewProvider {
    static var previews: some View {
        MottoView()
    }
}
