//
//  RecipeView.swift
//  Rezepte
//
//  Created by Daniel Bedrich on 02.03.20.
//  Copyright © 2020 Daniel Bedrich. All rights reserved.
//

import SwiftUI

struct RecipeView: View {
    @ObservedObject var viewModel: RecipeViewModel
    @State private var selectedTab: Int = 0
    
    init(_ recipe: Recipe) {
        self.viewModel = RecipeViewModel(recipe: recipe)
    }
    
    var body: some View {
        ScrollView {
            RecipeImage(viewModel: viewModel)
            HStack {
                RecipeTitle(viewModel: viewModel)
                Spacer()
                PreparationTime(viewModel: viewModel)
            }
            .padding(.horizontal)
            Picker(selection: $selectedTab, label: Text("")) {
                Text("Zutaten").tag(0)
                Text("Zubereitung").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            .labelsHidden()

            if selectedTab == 0 {
                Ingredients(viewModel: viewModel)
            } else {
                Preparation(viewModel: viewModel)
                if viewModel.recipe.tips != "" {
                    Tips(viewModel: viewModel)
                        .padding(.top, 25)
                }
            }
            Spacer().frame(height: 25)
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarItems(trailing: Favorite(viewModel: viewModel))
    }
}

struct RecipeImage: View {
    @ObservedObject var viewModel: RecipeViewModel
    
    var body: some View {
        Image(viewModel.recipe.image)
            .resizable()
            .scaledToFill()
            .frame(width: 250, height: 250)
            .clipped()
            .clipShape(Circle())
            .padding()
    }
}

struct RecipeTitle: View {
    @ObservedObject var viewModel: RecipeViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(viewModel.recipe.title)
                .font(.headline)
                .padding(.bottom, 5)
            Text(viewModel.recipe.primaryCategory)
                .font(.footnote)
        }
    }
}

struct Favorite: View {
    @ObservedObject var viewModel: RecipeViewModel
    
    var body: some View {
        if viewModel.recipe.isFavorite {
            return Button(action: {
                self.viewModel.deleteFromFavorites()
            }, label: {
                Image(systemName: "heart.fill")
                    .foregroundColor(.red)
                    .font(.title)
                    .frame(width: 25, height: 25)
            })
        } else {
            return Button(action: {
                self.viewModel.addToFavorites()
            }, label: {
                Image(systemName: "heart")
                    .foregroundColor(.red)
                    .font(.title)
                    .frame(width: 25, height: 25)
            })
        }
    }
}

struct PreparationTime: View {
    @ObservedObject var viewModel: RecipeViewModel
    
    var body: some View {
        Circle()
            .foregroundColor(.accentColor)
            .overlay(
                VStack {
                    Text("\(viewModel.recipe.time)")
                    Text("min")
                        .font(.footnote)
                }
                .foregroundColor(.white)
            )
        .frame(width: 60, height: 60)
    }
}

struct Ingredients: View {
    @ObservedObject var viewModel: RecipeViewModel
    
    var body: some View {
        Group {
            HStack {
                Button(action: {
                }, label: {
                    Image(systemName: "minus.circle")
                        .font(.largeTitle)
                        .onTapGesture {
                            self.viewModel.decreaseAmount(by: 1)
                        }
                        .onLongPressGesture {
                            self.viewModel.decreaseAmount(by: 10)
                        }
                })
                Spacer().frame(width: 50)
                Text(String(viewModel.amountCount))
                    .font(.largeTitle)
                    .frame(width: 50)
                Spacer().frame(width: 50)
                Button(action: {
                    self.viewModel.increaseAmount(by: 1)
                }, label: {
                    Image(systemName: "plus.circle")
                        .font(.largeTitle)
                        .onTapGesture {
                            self.viewModel.increaseAmount(by: 1)
                        }
                        .onLongPressGesture {
                            self.viewModel.increaseAmount(by: 10)
                        }
                })
            }
            Divider()
            ForEach(viewModel.ingredients, id: \.id) { ingredient in
                Group {
                    HStack {
                        Spacer()
                        Text(ingredient.amount)
                        Text(ingredient.unit)
                            .padding(.trailing)
                        Text(ingredient.type)
                            .frame(width: 175, alignment: .leading)
                    }
                    .padding(.horizontal, 25)
                    Divider()
                }
            }
            Spacer().frame(height: 20)
            Button(action: {
//                Add 1 from amount
            }, label: {
                Text("Zur Einkaufsliste hinzufügen")
            })
        }
    }
}

struct Preparation: View {
    @ObservedObject var viewModel: RecipeViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(viewModel.recipe.preparation, id: \.self) { preparation in
                Group {
                    Text(preparation)
                    Divider()
                }
                .padding(.horizontal)
            }
        }
    }
}

struct Tips: View {
    @ObservedObject var viewModel: RecipeViewModel
    
    var body: some View {
        HStack {
            Image(systemName: "info.circle")
                .font(.title)
                .padding(.trailing)
            Text(viewModel.recipe.tips)
        }
        .padding(.bottom)
        .padding(.horizontal, 25)
    }
}

struct RecipeView_Previews: PreviewProvider {
    static var previews: some View {
        let id = 1
        let image = "placeholder"
        let title = "Avocadoaufstrich"
        let ingredients = [Recipe.Ingredient(type: "reife Avocados", amount: "2", unit: ""),
                           Recipe.Ingredient(type: "Salz", amount: "1", unit: "TL"),
                           Recipe.Ingredient(type: "Hüttenkäse", amount: "", unit: "g")]
        let intolerances = [Recipe.Intolerance(type: "Gluten", image: .gluten),
                            Recipe.Intolerance(type: "Wheizen", image: .wheat)]
        let primaryCategory = "Frühstück, Mittagessen"
        let secondaryCategory = "Aufstrich, Backen"
        let tags = "#Frühstück, #Mittagessen, #Aufstriche, #Vegetarisch, #Laktose, #Halal"
        let preparation = ["1. Die Avocados halbieren und mit einem Löffel das Fruchtfleisch aus den Schalenhälften schälen und den Kern entfernen.", "2. Anschließend das Fruchtfleisch mit einer Gabel zerdrücken und die zerdrückte Avocado in eine Schüssel geben.", "3. Zitronensaft über das Avocadomus träufeln.", "4. Hüttenkäse dazuschütten und gut verrühren.", "5. Zum Schluss mit Salz und Pfeffer würzen."]
        let tips = "Passt sehr gut zu warmen Pellkartoffeln oder Ofenkartoffeln. Als Dip oder Aufstrich verwendbar."
        let source = "\"Das Kita-Kinder-Kochbuch\", S.22/23"
        
        return RecipeView(Recipe(id:id,
                                 image: image,
                                 title: title,
                                 ingredients: ingredients,
                                 intolerances: intolerances,
                                 primaryCategory: primaryCategory,
                                 secondaryCategory: secondaryCategory,
                                 tags: tags,
                                 time: 10,
                                 difficulty: .easy,
                                 preparation: preparation,
                                 tips: tips,
                                 source: source,
                                 isFavorite: true))
    }
}
