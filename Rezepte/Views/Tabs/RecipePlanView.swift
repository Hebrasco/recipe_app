//
//  RecipePlanView.swift
//  Rezepte
//
//  Created by Daniel Bedrich on 13.02.20.
//  Copyright © 2020 Daniel Bedrich. All rights reserved.
//

import SwiftUI

struct RecipePlanView: View {
    @ObservedObject var viewModel = RecipePlanViewModel()
    @State private var selectedTab: Int = 0
    let recipes = Recipes.recipes
    
    var body: some View {
        NavigationView {
            List {
                Section(header: SectionHeader(name: "Montag")) {
                    PlanRecipe(recipe: recipes[0])
                }
                Section(header: SectionHeader(name: "Dienstag")) {
                    PlanRecipe(recipe: recipes[1])
                }
                Section(header: SectionHeader(name: "Mittwoch")) {
                    PlanRecipe(recipe: recipes[2])
                }
                Section(header: SectionHeader(name: "Donnerstag")) {
                    PlanRecipe(recipe: recipes[3])
                }
                Section(header: SectionHeader(name: "Freitag")) {
                    PlanRecipe(recipe: recipes[4])
                }
            }
            .navigationBarTitle("Wochenplan")
        }
    }
}

struct SectionHeader: View {
    @State private var showRecipeSheet = false
    let recipes = Recipes.recipes
    let name: String
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                Text(self.name)
                    .frame(width: geometry.size.width / 2, alignment: .leading)
                Button(action: {
                    self.showRecipeSheet.toggle()
                }, label: {
                    Image(systemName: "plus.circle")
                        .frame(width: geometry.size.width / 2, alignment: .trailing)
                        .font(.system(size: 20))
                })
                .sheet(isPresented: self.$showRecipeSheet, content: {
                    List {
                        ForEach(self.recipes.indices, id: \.self) { index in
                            RecipeCard(recipe: self.recipes[index])
//                            Card are grayed out because of the navigation links privided. Should be removed in sheet.
                        }
                    }
                })
            }
        }
    }
}

struct PlanRecipe: View {
    let recipe: Recipe
    
    var body: some View {
        HStack {
            Image(recipe.image)
                .resizable()
                .frame(width: 50, height: 50)
                .clipped()
                .clipShape(Circle())
                .padding(.trailing)
            Text(recipe.title)
        }
        .frame(height: 50)
    }
}

struct RecipePlanView_Previews: PreviewProvider {
    static var previews: some View {
        RecipePlanView()
    }
}
