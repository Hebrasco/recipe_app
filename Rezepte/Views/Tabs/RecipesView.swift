//
//  RecipesView.swift
//  Rezepte
//
//  Created by Daniel Bedrich on 13.02.20.
//  Copyright © 2020 Daniel Bedrich. All rights reserved.
//

import SwiftUI

struct RecipesView: View {
    @State var recipes: [Recipe] = []
    @State var showFilterSheet = false
    
    var body: some View {
        NavigationView {
            List {
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
                ForEach(recipes, id: \.id) { recipe in
                    RecipeCard(recipe, with: .Navigation)
                }
            }
            .onAppear(perform: {
                self.recipes = Recipes.getRecipes()
            })
            .sheet(isPresented: $showFilterSheet,
                   onDismiss: {
                        print("test")},
                   content: {
                    Filter().accentColor(.init("AccentColor"))
            })
            .navigationBarTitle("Rezepte")
            .navigationBarItems(trailing: Button(action: {
                self.showFilterSheet.toggle()
            }, label: {
                Image(systemName: "line.horizontal.3.decrease.circle")
            }))
        }
    }
}

struct RecipesView_Previews: PreviewProvider {
    static var previews: some View {
        RecipesView()
    }
}
