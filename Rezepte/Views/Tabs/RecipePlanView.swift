//
//  RecipePlanView.swift
//  Rezepte
//
//  Created by Daniel Bedrich on 13.02.20.
//  Copyright © 2020 Daniel Bedrich. All rights reserved.
//

import SwiftUI

struct RecipePlanView: View {
    @ObservedObject private var viewModel = RecipePlanViewController()
    @State private var selectedTab: Int = 0
    @State private var showActionSheet = false
    @State private var showDismissAlert = false
    @State private var showSheet = false
    @State private var sheetContent: RecipePlanViewController.SheetContent = .load
    
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
            .sheet(isPresented: $showSheet, onDismiss: {
            }, content: {
                SheetContent(viewModel: self.viewModel,
                             showSheet: self.$showSheet,
                             sheetContent: self.$sheetContent)
            })
            .actionSheet(isPresented: $showActionSheet, content: {
                ActionSheet(title: Text("Speiseplan bearbeiten"),
                            buttons: [.default(Text("Speichern"), action: {
                                        self.sheetContent = .save
                                        self.showSheet.toggle()
                                      }),
                                      .default(Text("Laden"), action: {
                                          self.sheetContent = .load
                                        self.showSheet.toggle()
                                      }),
                                      .destructive(Text("Löschen"), action: {
                                          self.sheetContent = .delete
                                          self.showSheet.toggle()
//                                        self.viewModel.removeLoadedRecipes()
                                      }),
                                      .cancel(Text("Abbrechen"))])
            })
            .alert(isPresented: $showDismissAlert, content: {
                Alert(title: Text("Speiseplan verwerfen"),
                     message: Text("Sind Sie sicher, dass Sie den Aktuellen Speiseplan verwerfen möchten?"),
                     primaryButton: .destructive(Text("Verwerfen"), action: {
                        self.viewModel.removeLoadedRecipes()
                     }),
                     secondaryButton: .cancel(Text("Abbrechen")))
            })
            .navigationBarTitle("Speiseplan")
            .navigationBarItems(trailing: HStack{
                Button(action: {
                    self.showActionSheet.toggle()
                }, label: {
                    Image(systemName: "ellipsis.circle")
                        .imageScale(.large)
                })
                .padding(.trailing)
                Button(action: {
                    self.showDismissAlert.toggle()
                }, label: {
                    Image(systemName: "trash")
                        .imageScale(.large)
                })
            })
        }
        .padding()
    }
}

struct SheetContent: View {
    @ObservedObject var viewModel: RecipePlanViewController
    @Binding var showSheet: Bool
    @Binding var sheetContent: RecipePlanViewController.SheetContent
    
    var body: some View {
        switch sheetContent {
        case .save: return AnyView(SheetContentSavePlan(viewModel: viewModel, showSheet: $showSheet))
            case .load: return AnyView(SheetContentLoadPlan(viewModel: viewModel, showSheet: $showSheet))
            case .delete: return AnyView(SheetContentDeletePlan(viewModel: viewModel, showSheet: $showSheet))
        }
    }
}

struct SectionHeader: View {
    @State private var showRecipeSheet = false
    @State private var searchText = ""
    private let recipes = Recipes.getRecipes()
    private let name: String
    private let weekday: RecipePlanViewController.WeekDays
    private let viewModel: RecipePlanViewController
    
    init(name: String, weekday: RecipePlanViewController.WeekDays, viewModel: RecipePlanViewController) {
        self.name = name
        self.weekday = weekday
        self.viewModel = viewModel
    }
    
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
    private let weekday: RecipePlanViewController.WeekDays
    private let viewModel: RecipePlanViewController
    private let recipes: [RecipePlanViewController.PlanRecipe]
        
    init(_ weekday: RecipePlanViewController.WeekDays, viewModel: RecipePlanViewController) {
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

struct SheetContentSavePlan: View {
    @ObservedObject var viewModel: RecipePlanViewController
    @Binding var showSheet: Bool
    @State var recentlySavedName = ""
    
    var body: some View {
        Form {
            TextField("Name", text: $recentlySavedName)
            Button(action: {
                self.viewModel.saveRecipePlan(name: self.recentlySavedName)
                self.showSheet.toggle()
            }, label: {
                Text("Speichern")
            })
        }
    }
}

struct SheetContentLoadPlan: View {
    @ObservedObject var viewModel: RecipePlanViewController
    @Binding var showSheet: Bool
    
    var body: some View {
        List {
            ForEach(viewModel.savedPlans, id: \.id) { plan in
                Button(action: {
                    self.viewModel.loadRecipePlan(plan)
                    self.showSheet.toggle()
                }, label: {
                    VStack(alignment: .leading) {
                        Text(plan.name)
                        Text("\(plan.createdAt)")
                            .font(.footnote)
                    }
                })
            }
        }
    }
}

struct SheetContentDeletePlan: View {
    @ObservedObject var viewModel: RecipePlanViewController
    @Binding var showSheet: Bool
    @State var showDeleteAlert = false
    
    var body: some View {
        List {
            ForEach(viewModel.savedPlans, id: \.id) { plan in
                Button(action: {
                    self.showDeleteAlert.toggle()
                }, label: {
                    VStack(alignment: .leading) {
                        Text(plan.name)
                        Text("\(plan.createdAt)")
                            .font(.footnote)
                    }
                })
                .alert(isPresented: self.$showDeleteAlert, content: {
                    Alert(title: Text("Speiseplan löschen"),
                          message: Text("Sind Sie sicher, dass die den Speiseplan löschen wollen?"),
                          primaryButton: .cancel(Text("Abbrechen")),
                          secondaryButton: .destructive(Text("Löschen"), action: {
                            self.viewModel.deleteReciePlan(plan)
                          }))
                })
            }
        }
    }
}

struct RecipePlanView_Previews: PreviewProvider {
    static var previews: some View {
        RecipePlanView()
    }
}
