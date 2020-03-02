//
//  RecipeView.swift
//  Rezepte
//
//  Created by Daniel Bedrich on 02.03.20.
//  Copyright © 2020 Daniel Bedrich. All rights reserved.
//

import SwiftUI

struct RecipeView: View {
    let recipe: Recipe
    
    var body: some View {
        ScrollView {
            RecipeImage(recipe: recipe)
            HStack {
                RecipeTitle(recipe: recipe)
                Spacer()
                PreperationTime(recipe: recipe)
            }
            .padding(.horizontal)
            VStack(alignment: .leading) {
                Favorite()
                Divider()
                Ingredients(recipe: recipe)
                Spacer().frame(height: 20)
                Preperation(recipe: recipe)
            }
            .padding(.horizontal)
        }
        .navigationBarTitle("", displayMode: .inline)
    }
}

private struct RecipeImage: View {
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

private struct RecipeTitle: View {
    let recipe: Recipe
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(recipe.title)
                .font(.headline)
                .padding(.bottom, 5)
            Text(recipe.category)
                .font(.footnote)
        }
    }
}

private struct Favorite: View {
    var body: some View {
        Image(systemName: "heart.fill")
        .foregroundColor(.red)
        .font(.title)
        .padding(.bottom)
    }
}

private struct PreperationTime: View {
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
                .foregroundColor(Color(UIColor.systemBackground))
            )
        .frame(width: 60, height: 60)
    }
}

private struct Ingredients: View {
    let recipe: Recipe
    
    var body: some View {
        Group {
            Text("Zutaten:")
            ForEach(recipe.ingredients.indices, id: \.self) { index in
                HStack {
                    Text("\(self.recipe.ingredients[index].amount)")
                    Text("\(self.recipe.ingredients[index].type)")
                    Spacer()
                }
                .padding(.horizontal, 35)
            }
        }
    }
}

private struct Preperation: View {
    let recipe: Recipe
    
    var body: some View {
        Group {
            Text("Zubereitung:")
            Text(recipe.preparation)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 35)
        }
    }
}

struct RecipeView_Previews: PreviewProvider {
    static var previews: some View {
        let image = "placeholder"
        let title = "Avocadoaufstrich"
        let ingredients = [Recipe.Ingredient(type: "reife Avocados", amount: "2"),
                           Recipe.Ingredient(type: "Salz", amount: "3")]
        let intolerances = [Recipe.Intolerance(type: "Gluten", image: .gluten),
                            Recipe.Intolerance(type: "Wheizen", image: .wheat)]
        let category = "Frühstück,Mittagessen"
        let tags = "Frühstück,Mittagessen,Aufstriche,Vegetarisch,Laktose,Halal"
        let preperation = "1. Die Avocados halbieren und mit einem Löffel das Fruchtfleisch aus den Schalenhälften schälen und den Kern entfernen.\n2. Anschließend das Fruchtfleisch mit einer Gabel zerdrücken und die zerdrückte Avocado in eine Schüssel geben.\n3. Zitronensaft über das Avocadomus träufeln.\n4. Hüttenkäse dazuschütten und gut verrühren.\n5. Zum Schluss mit Salz und Pfeffer würzen."
        let tips = "Passt sehr gut zu warmen Pellkartoffeln oder Ofenkartoffeln. Als Dip oder Aufstrich verwendbar."
        let source = "\"Das Kita-Kinder-Kochbuch\", S.22/23"
        
        return RecipeView(recipe: Recipe(image: image,
                                  title: title,
                                  ingredients: ingredients,
                                  intolerances: intolerances,
                                  category: category,
                                  tags: tags,
                                  time: 10,
                                  difficulty: .easy,
                                  preparation: preperation,
                                  tips: tips,
                                  source: source))
    }
}
