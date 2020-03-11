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
    let mondayRecipes = [Recipes.recipes[0], Recipes.recipes[1]]
    let thuesdayRecipes = [Recipes.recipes[2], Recipes.recipes[3]]
    let wednesdayRecipes = [Recipes.recipes[4], Recipes.recipes[5]]
    let thursdayRecipes = [Recipes.recipes[6], Recipes.recipes[7]]
    let fridayRecipes = [Recipes.recipes[8], Recipes.recipes[9]]
    
    var body: some View {
        NavigationView {
            List {
                Section(header: SectionHeader(name: "Montag")) {
                    RecipesOfWeekDay(recipes: mondayRecipes)
                }
                Section(header: SectionHeader(name: "Dienstag")) {
                    RecipesOfWeekDay(recipes: thuesdayRecipes)
                }
                Section(header: SectionHeader(name: "Mittwoch")) {
                    RecipesOfWeekDay(recipes: wednesdayRecipes)
                }
                Section(header: SectionHeader(name: "Donnerstag")) {
                    RecipesOfWeekDay(recipes: thursdayRecipes)
                }
                Section(header: SectionHeader(name: "Freitag")) {
                    RecipesOfWeekDay(recipes: fridayRecipes)
                }
            }
            .navigationBarTitle("Wochenplan")
        }
    }
}

struct SectionHeader: View {
    @State private var showRecipeSheet = false
    @State private var searchText = ""
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
                    VStack {
                        SearchBar(text: self.$searchText)
                            .padding(.top)
                            .padding(.bottom, 8)
                        List {
                            ForEach(self.recipes, id: \.id) { recipe in
                                RecipeCard(recipe)
//                                Card are grayed out because of the navigation links privided. Should be removed in sheet.
                            }
                        }
                    }
                    .accentColor(Color.init("AccentColor"))
                })
            }
        }
    }
}

struct RecipesOfWeekDay: View {
    let recipes: [Recipe]
    
    var body: some View {
        ForEach(recipes, id: \.id) { recipe in
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
        .onDelete(perform: { indexSet in
            print("gesture delete performed on recipe")
        })
        
    }
}

struct RecipePlanView_Previews: PreviewProvider {
    static var previews: some View {
        RecipePlanView()
    }
}
