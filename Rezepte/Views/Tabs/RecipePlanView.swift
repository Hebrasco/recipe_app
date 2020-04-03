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
    
    var body: some View {
        NavigationView {
            List {
                Section(header: SectionHeader(name: "Montag",
                                              weekday: .monday,
                                              viewModel: viewModel)) {
                    RecipesOfWeekDay(.monday, viewModel: viewModel)
                }
                Section(header: SectionHeader(name: "Dienstag",
                                              weekday:  .thuesday,
                                              viewModel: viewModel)) {
                    RecipesOfWeekDay(.thuesday, viewModel: viewModel)
                }
                Section(header: SectionHeader(name: "Mittwoch",
                                              weekday:  .wednesday,
                                              viewModel: viewModel)) {
                    RecipesOfWeekDay(.wednesday, viewModel: viewModel)
                }
                Section(header: SectionHeader(name: "Donnerstag",
                                              weekday:  .thursday,
                                              viewModel: viewModel)) {
                    RecipesOfWeekDay(.thursday, viewModel: viewModel)
                }
                Section(header: SectionHeader(name: "Freitag",
                                              weekday:  .friday,
                                              viewModel: viewModel)) {
                    RecipesOfWeekDay(.friday, viewModel: viewModel)
                }
            }
            .navigationBarTitle("Wochenplan")
            .navigationBarItems(trailing: Button(action: {
                self.viewModel.removeAllRecipes()
            }, label: {
                Image(systemName: "trash")
            }))
        }
    }
}

struct SectionHeader: View {
    @State private var showRecipeSheet = false
    @State private var searchText = ""
    let recipes = Recipes.getRecipes()
    let name: String
    let weekday: RecipePlanViewModel.WeekDays
    let viewModel: RecipePlanViewModel
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                Text(self.name)
                Spacer()
                Button(action: {
                    self.showRecipeSheet.toggle()
                }, label: {
                    Image(systemName: "plus.circle")
                        .font(.system(size: 20))
                })
                .sheet(isPresented: self.$showRecipeSheet, content: {
                    VStack {
                        HStack {
                            SearchBar(text: self.$searchText)
                                .padding(.top)
                                .padding(.bottom, 8)
                            Button(action: {
                                self.showRecipeSheet.toggle()
                            }, label: {
                                Text("Fertig")
                            })
                            .padding(.trailing)
                        }
                        List {
                            ForEach(self.recipes, id: \.id) { recipe in
                                RecipeCard(recipe, with: .Button, onWeekDay: self.weekday)
                            }
                        }
                    }
                    .accentColor(Color.init("AccentColor"))
                    .onDisappear(perform: {
                        self.viewModel.loadRecipes()
                    })
                })
            }
        }
    }
}

struct RecipesOfWeekDay: View {
    let weekday: RecipePlanViewModel.WeekDays
    let viewModel: RecipePlanViewModel
    let recipes: [RecipePlanViewModel.PlanRecipe]
        
    init(_ weekday: RecipePlanViewModel.WeekDays, viewModel: RecipePlanViewModel) {
        self.weekday = weekday
        self.viewModel = viewModel
        
        switch weekday {
        case .monday:
            recipes = viewModel.mondayRecipes
            break
        case .thuesday:
            recipes = viewModel.thuesdayRecipes
            break
        case .wednesday:
            recipes = viewModel.wednesdayRecipes
            break
        case .thursday:
            recipes = viewModel.thursdayRecipes
            break
        case .friday:
            recipes = viewModel.fridayRecipes
            break
        }
    }
    
    var body: some View {
        ForEach(recipes.sorted{ $0.mealType < $1.mealType}, id: \.id) { planRecipe in
            NavigationLink(destination: RecipeView(planRecipe.recipe), label: {
                HStack {
                    Image(planRecipe.recipe.image)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipped()
                        .clipShape(Circle())
                        .padding(.trailing)
                    Text(planRecipe.recipe.title)
                    Spacer()
                    Image(planRecipe.mealType)
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.accentColor)
                }
                .frame(height: 50)
            })
        
        }
        .onDelete(perform: { indexSet in
            self.viewModel.removeRecipe(with: indexSet, from: self.weekday)
        })
        
    }
}

struct RecipePlanView_Previews: PreviewProvider {
    static var previews: some View {
        RecipePlanView()
    }
}
