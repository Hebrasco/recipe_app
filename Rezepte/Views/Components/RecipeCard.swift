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
    
    var body: some View {
        NavigationLink(destination: RecipeView(recipe: recipe)) {
            VStack(alignment: .leading, spacing: 20) {
                Image(recipe.image)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 150)
                    .clipped()
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
                    ForEach(recipe.intolerances.indices, id: \.self) { index in
                        Intolerance(intolerance: self.recipe.intolerances[index])
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
            .frame(height: 300)
            .background(Color.init(UIColor.systemBackground))
            .cornerRadius(10)
            .padding(.vertical)
            .shadow(radius: 10)
        }
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
        let image = "placeholder"
        let title = "Bunter Nudelauflauf mit Schinken"
        let ingredients = [Recipe.Ingredient(type: "reife Avocados", amount: "2"),
                           Recipe.Ingredient(type: "Salz", amount: "3")]
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
        
        return RecipeCard(recipe: Recipe(image: image,
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
