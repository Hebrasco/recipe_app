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
                Intolerances(intolerance: recipe.intolerances[0])
                Intolerances(intolerance: recipe.intolerances[1])
                Intolerances(intolerance: recipe.intolerances[0])
                Intolerances(intolerance: recipe.intolerances[1])
                Intolerances(intolerance: recipe.intolerances[0])
                Intolerances(intolerance: recipe.intolerances[1])
            }
            .padding(.horizontal)
            Text(recipe.tags)
                .font(.caption)
                .padding([.horizontal, .bottom])
        }
        .background(Color.white)
        .cornerRadius(10)
        .padding(.vertical)
        .shadow(radius: 10)
    }
}

struct Intolerances: View {
    let intolerance: String
    
    var body: some View {
        VStack(spacing: 0) {
            Image(intolerance)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundColor(.accentColor)
            Text(intolerance)
                .font(.caption)
        }
        .padding(.trailing, 5)
    }
}

struct Recipe_Previews: PreviewProvider {
    static var previews: some View {
        RecipeCard(recipe: Recipe(image: "placeholder", title: "Aufstrich", ingredients: [], intolerances: ["wheat", "halal"], category: "Frühstück", tags: "Frühstück, Essen, Sonstige Tags", time: 20, difficulty: .medium))
    }
}
