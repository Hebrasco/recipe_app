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
        NavigationView {
            VStack(alignment: .center) {
                Category(name: "Früchstück",
                          image: "breakfast",
                          destination: AnyView(BreakfastView()))
                Category(name: "Mittagessen",
                          image: "lunch",
                          destination: AnyView(LunchView()))
                Category(name: "Nachtisch/Snack",
                          image: "snack",
                          destination: AnyView(SnackView()))
                Category(name: "Motto/Anlässe",
                          image: "motto",
                          destination: AnyView(MottoView()))
            }
            .navigationBarTitle("Rezepte")
        }
    }
}

struct Category: View {
    let name: String
    let image: String
    let destination: AnyView
    
    var body: some View {
        NavigationLink(
            destination: destination,
            label: {
                VStack {
                Image(image)
                    .resizable()
                    .frame(width: 100, height: 100)
                Text(name)
                    .foregroundColor(.primary)
                }
            }
        )
    }
}

struct RecipesView_Previews: PreviewProvider {
    static var previews: some View {
        RecipesView()
    }
}
