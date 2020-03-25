//
//  RecipePlanView.swift
//  Rezepte
//
//  Created by Daniel Bedrich on 13.02.20.
//  Copyright © 2020 Daniel Bedrich. All rights reserved.
//

import SwiftUI

struct RecipePlanView: View {
    @ObservedObject var viewModel: RecipePlanViewModel
    @State private var selectedTab: Int = 0
    @State var mondayRecipes: [Recipe] = []
    @State var thuesdayRecipes: [Recipe] = []
    @State var wednesdayRecipes: [Recipe] = []
    @State var thursdayRecipes: [Recipe] = []
    @State var fridayRecipes: [Recipe] = []
    
    init() {
        self.viewModel = RecipePlanViewModel()
        self.mondayRecipes = viewModel.mondayRecipes
        self.thuesdayRecipes = viewModel.thuesdayRecipes
        self.wednesdayRecipes = viewModel.wednesdayRecipes
        self.thursdayRecipes = viewModel.thuesdayRecipes
        self.fridayRecipes = viewModel.fridayRecipes
    }
    
    var body: some View {
        NavigationView {
            List {
                Section(header: SectionHeader(name: "Montag", weekday: .monday)) {
                    RecipesOfWeekDay(recipes: mondayRecipes)
                }
                Section(header: SectionHeader(name: "Dienstag", weekday:  .thuesday)) {
                    RecipesOfWeekDay(recipes: thuesdayRecipes)
                }
                Section(header: SectionHeader(name: "Mittwoch", weekday:  .wednesday)) {
                    RecipesOfWeekDay(recipes: wednesdayRecipes)
                }
                Section(header: SectionHeader(name: "Donnerstag", weekday:  .thursday)) {
                    RecipesOfWeekDay(recipes: thursdayRecipes)
                }
                Section(header: SectionHeader(name: "Freitag", weekday:  .friday)) {
                    RecipesOfWeekDay(recipes: fridayRecipes)
                }
            }
            .navigationBarTitle("Wochenplan")
            .onAppear(perform: {
                self.viewModel.leadRecipes()
                self.mondayRecipes = self.viewModel.mondayRecipes
                self.thuesdayRecipes = self.viewModel.thuesdayRecipes
                self.wednesdayRecipes = self.viewModel.wednesdayRecipes
                self.thursdayRecipes = self.viewModel.thursdayRecipes
                self.fridayRecipes = self.viewModel.fridayRecipes
            })
        }
    }
}

struct SectionHeader: View {
    @State private var showRecipeSheet = false
    @State private var searchText = ""
    let recipes = Recipes.getRecipes()
    let name: String
    let weekday: RecipeCardViewModel.WeekDays
    
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
                                RecipeCard(recipe, with: .Button, onWeekDay: self.weekday)
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
