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
        recipies = jsonParser.parseRecipes()
    }
    
    var body: some View {
        List {
            Category(name: "Fasching",
                     image: "carnevall",
                     destination: AnyView(CarnevallView()))
            Category(name: "Ostern",
                     image: "easter",
                     destination: AnyView(EasterView()))
            Category(name: "Halloween",
                     image: "halloween",
                     destination: AnyView(HalloweenView()))
            Category(name: "Weihnachten",
                     image: "xmas",
                     destination: AnyView(XMasView()))
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
