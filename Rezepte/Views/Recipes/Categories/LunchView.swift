//
//  LunchView.swift
//  Rezepte
//
//  Created by Daniel Bedrich on 18.02.20.
//  Copyright © 2020 Daniel Bedrich. All rights reserved.
//

import SwiftUI

struct LunchView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 10) {
                Category(name: "Fleisch",
                          image: "meat",
                          destination: AnyView(MeatView()))
                Category(name: "Fish",
                          image: "fish",
                          destination: AnyView(FishView()))
                Category(name: "Vegetarisch",
                          image: "vegetarian",
                          destination: AnyView(VegetarianView()))
                Category(name: "Pasta & Co",
                          image: "pasta",
                          destination: AnyView(PastaView()))
                Category(name: "Süßes",
                          image: "sweets",
                          destination: AnyView(SweetsView()))
                Category(name: "Suppen",
                          image: "soup",
                          destination: AnyView(SoupView()))
            }
            .frame(width: UIScreen.main.bounds.width)
        }
        .navigationBarTitle("Mittagessen", displayMode: .inline)
    }
}

struct LunchView_Previews: PreviewProvider {
    static var previews: some View {
        LunchView()
    }
}
