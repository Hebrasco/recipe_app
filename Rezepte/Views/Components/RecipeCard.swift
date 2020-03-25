//
//  RecipeCard.swift
//  Rezepte
//
//  Created by Daniel Bedrich on 19.02.20.
//  Copyright © 2020 Daniel Bedrich. All rights reserved.
//

import SwiftUI

struct RecipeCard: View {
    let recipe: Recipe
    let type: PressAction
    
    init(_ recipe: Recipe, with type: PressAction) {
        self.recipe = recipe
        self.type = type
    }
    
    var body: some View {
        VStack {
            if type == .Navigation {
                NavigationLink(destination: RecipeView(recipe)) {
                    Card(recipe)
                }
            } else {
                Button(action: {
                    print("Add to weekly plan")
                }, label: {
                    Card(recipe)
                })
            }
        }
    }
    
    enum PressAction {
        case Navigation
        case Button
    }
}

struct Card: View {
    let recipe: Recipe
    
    init(_ recipe: Recipe) {
        self.recipe = recipe
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Image(recipe.image)
                .renderingMode(.original)
                .resizable()
                .scaledToFill()
                .frame(height: 150)
                .clipped()
            VStack(alignment: .leading) {
                HStack {
                    Text(recipe.title)
                        .font(.headline)
                    Spacer()
                    VStack {
                        Image(systemName: "timer")
                            .multilineTextAlignment(.trailing)
                            .foregroundColor(.accentColor)
                        Text("\(recipe.time) Minuten")
                            .font(.caption)
                    }
                    .frame(width: 90)
                    Spacer().frame(width: 5)
                    VStack {
                        Image(systemName: "gauge")
                            .frame(alignment: .trailing)
                            .foregroundColor(.accentColor)
                        Text(recipe.difficulty.rawValue)
                            .font(.caption)
                    }
                }
                .padding(.horizontal)
                HStack {
                    ForEach(recipe.intolerances, id: \.id) { intolerance in
                        Intolerance(intolerance: intolerance)
                    }
                }
                .padding(.horizontal)
                HStack {
                    Text(recipe.tags)
                        .font(.caption)
                        .fixedSize(horizontal: false, vertical: true)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
                .padding(.horizontal)
                Spacer()
            }
            .frame(height: 150)
        }
        .frame(height: 300)
        .background(Color.init(UIColor.systemBackground))
        .cornerRadius(10)
        .padding(.vertical)
        .shadow(radius: 10)
    }
}

struct Intolerance: View {
    let intolerance: Recipe.Intolerance
    
    var body: some View {
        Image(intolerance.image.rawValue)
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
            .frame(width: 20, height: 20)
            .foregroundColor(.accentColor)
    }
}

struct Recipe_Previews: PreviewProvider {
    static var previews: some View {
        let id = 1
        let image = "placeholder"
        let title = "Bunter Nudelauflauf mit Schinken"
        let ingredients = [Recipe.Ingredient(type: "reife Avocados", amount: "2", unit: ""),
        Recipe.Ingredient(type: "Salz", amount: "1", unit: "TL"),
        Recipe.Ingredient(type: "Hüttenkäse", amount: "200", unit: "g")]
        let intolerances = [Recipe.Intolerance(type: "Gluten", image: .gluten),
        Recipe.Intolerance(type: "Weizen", image: .wheat),
        Recipe.Intolerance(type: "Laktose", image: .lactose),
        Recipe.Intolerance(type: "Vegetarisch", image: .vegetarian),
        Recipe.Intolerance(type: "Vegetarisch", image: .vegetarian),
        Recipe.Intolerance(type: "Vegan", image: .vegan),
        Recipe.Intolerance(type: "Vegetarisch", image: .vegetarian)]
        
        let primaryCategory = "Frühstück, Mittagessen"
        let secondaryCategory = "Aufstrich, Backen"
        let tags = "#Frühstück, #Mittagessen, #Aufstriche, #Vegetarisch, #Laktose, #Halal"
        let preparation = ["1. Die Avocados halbieren und mit einem Löffel das Fruchtfleisch aus den Schalenhälften schälen und den Kern entfernen.", "2. Anschließend das Fruchtfleisch mit einer Gabel zerdrücken und die zerdrückte Avocado in eine Schüssel geben.", "3. Zitronensaft über das Avocadomus träufeln.", "4. Hüttenkäse dazuschütten und gut verrühren.", "5. Zum Schluss mit Salz und Pfeffer würzen."]
        let tips = "Passt sehr gut zu warmen Pellkartoffeln oder Ofenkartoffeln. Als Dip oder Aufstrich verwendbar."
        let source = "\"Das Kita-Kinder-Kochbuch\", S.22/23"
        
        return RecipeCard(Recipe(id: id,
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
                                 isFavorite: true), with: .Navigation)
    }
}
