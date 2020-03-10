//
//  RecipeView.swift
//  Rezepte
//
//  Created by Daniel Bedrich on 02.03.20.
//  Copyright © 2020 Daniel Bedrich. All rights reserved.
//

import SwiftUI

struct RecipeView: View {
    @State private var selectedTab: Int = 0
    let recipe: Recipe
    
    var body: some View {
        ScrollView {
            RecipeImage(recipe: recipe)
            HStack {
                RecipeTitle(recipe: recipe)
                Spacer()
                PreparationTime(recipe: recipe)
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
                Ingredients(recipe: recipe)
            } else {
                Preparation(recipe: recipe)
                if recipe.tips != "" {
                    Tips(recipe: recipe)
                        .padding(.top, 25)
                }
            }
            Spacer().frame(height: 25)
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarItems(trailing: Favorite())
    }
}

struct RecipeImage: View {
    let recipe: Recipe
    
    var body: some View {
        Image(recipe.image)
            .resizable()
            .scaledToFill()
            .frame(width: 250, height: 250)
            .clipped()
            .clipShape(Circle())
            .padding()
    }
}

struct RecipeTitle: View {
    let recipe: Recipe
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(recipe.title)
                .font(.headline)
                .padding(.bottom, 5)
            Text(recipe.primaryCategory)
                .font(.footnote)
        }
    }
}

struct Favorite: View {
    var body: some View {
        Image(systemName: "heart.fill")
            .foregroundColor(.red)
            .font(.title)
    }
}

struct PreparationTime: View {
    let recipe: Recipe
    
    var body: some View {
        Circle()
            .foregroundColor(.accentColor)
            .overlay(
                VStack {
                    Text("\(recipe.time)")
                    Text("min")
                        .font(.footnote)
                }
                .foregroundColor(.white)
            )
        .frame(width: 60, height: 60)
    }
}

struct Ingredients: View {
    let recipe: Recipe
    
    var body: some View {
        Group {
            HStack {
                Button(action: {
//                  Subtract 1 to amount
                }, label: {
                    Image(systemName: "minus.circle").font(.largeTitle)
                })
                Spacer().frame(width: 50)
                Text("1").font(.largeTitle)
                Spacer().frame(width: 50)
                Button(action: {
//                  Add 1 from amount
                }, label: {
                    Image(systemName: "plus.circle").font(.largeTitle)
                })
            }
            Divider()
            ForEach(recipe.ingredients.indices, id: \.self) { index in
                Group {
                    HStack {
                        Spacer()
                        Text(self.recipe.ingredients[index].amount)
                        Text(self.recipe.ingredients[index].unit)
                            .padding(.trailing)
                        Text(self.recipe.ingredients[index].type)
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
    let recipe: Recipe
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(recipe.preparation, id: \.self) { preparation in
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
    let recipe: Recipe
    
    var body: some View {
        HStack {
            Image(systemName: "info.circle")
                .font(.title)
                .padding(.trailing)
            Text(recipe.tips)
        }
        .padding(.bottom)
        .padding(.horizontal, 25)
    }
}

struct RecipeView_Previews: PreviewProvider {
    static var previews: some View {
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
        
        return RecipeView(recipe: Recipe(image: image,
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
                                  source: source))
    }
}
