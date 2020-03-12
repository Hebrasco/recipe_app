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
    var recipe: Recipe
    
    init(_ recipe: Recipe) {
        self.recipe = recipe
        self.viewModel = RecipeViewModel(ingredients: recipe.ingredients)
    }
    
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
                Ingredients(viewModel: viewModel)
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
        .navigationBarItems(trailing: Favorite(recipe))
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
    @Environment(\.managedObjectContext) var context
    @FetchRequest(entity: FavoriteEntity.entity(), sortDescriptors: []) var favorites: FetchedResults<FavoriteEntity>
    var recipe: Recipe
    
    init(_ recipe: Recipe) {
        self.recipe = recipe
    }
    
    var body: some View {
        if recipe.isFavorite {
            return Button(action: {
                self.deleteFromFavorites()
            }, label: {
                Image(systemName: "heart.fill")
                    .foregroundColor(.red)
                    .font(.title)
                    .frame(width: 25, height: 25)
            })
        } else {
            return Button(action: {
                self.addToFavorites()
            }, label: {
                Image(systemName: "heart")
                    .foregroundColor(.red)
                    .font(.title)
                    .frame(width: 25, height: 25)
            })
        }
    }
    
    func addToFavorites() {
        if !favorites.contains(where: {$0.recipe_id == recipe.id}) {
            print("adding \(recipe.id) from Favorites")
            
            let favoriteEntity = FavoriteEntity(context: context)
            favoriteEntity.recipe_id = Int32(recipe.id)
            
            try? context.save()
            
            Recipes.parse()
            for recipe in Recipes.recipes.filter({$0.isFavorite}) {
                print(recipe.id)
            }
        }
    }
    
    func deleteFromFavorites() {
        if favorites.contains(where: {$0.recipe_id == recipe.id}) {
//            remove recipe from favorites
            print("deleting \(recipe.id) from Favorites")
        }
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
