//
//  RecipeCard.swift
//  Rezepte
//
//  Created by Daniel Bedrich on 19.02.20.
//  Copyright © 2020 Daniel Bedrich. All rights reserved.
//

import SwiftUI

struct RecipeCard: View {
    let image: String
    let title: String
    let ingredients: [String]
    let intolerances: [String]
    let category: String
    let tags: String
    let time: Int
    let difficulty: Difficulty
    
    enum Difficulty: String {
        case easy = "Einfach"
        case medium = "Mittel"
        case hard = "Schwer"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Image(image)
                .resizable()
                .scaledToFill()
                .frame(height: 150)
                .clipped()
            HStack {
                Text(title)
                    .font(.headline)
                Spacer()
                VStack {
                    Image(systemName: "timer")
                        .multilineTextAlignment(.trailing)
                    Text("\(time) Minuten")
                        .font(.caption)
                }
                .frame(width: 90)
                Spacer().frame(width: 5)
                VStack {
                    Image(systemName: "gauge")
                        .frame(alignment: .trailing)
                    Text(difficulty.rawValue)
                        .font(.caption)
                }
            }
            .padding(.horizontal)
            HStack {
                Intolerances(intolerance: intolerances[0])
                Intolerances(intolerance: intolerances[1])
                Intolerances(intolerance: intolerances[0])
                Intolerances(intolerance: intolerances[1])
                Intolerances(intolerance: intolerances[0])
                Intolerances(intolerance: intolerances[1])
            }
            .padding(.horizontal)
            Text(tags)
                .font(.caption)
                .padding([.horizontal, .bottom])
        }
        .background(Color.gray)
        .cornerRadius(10)
        .padding()
        .shadow(radius: 10)
    }
}

struct Intolerances: View {
    let intolerance: String
    
    var body: some View {
        VStack(spacing: 0) {
            Image(intolerance)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
            Text(intolerance)
                .font(.caption)
        }
        .padding([.leading, .trailing], 5)
    }
}

struct Recipe_Previews: PreviewProvider {
    static var previews: some View {
        RecipeCard(image: "placeholder", title: "Aufstrich", ingredients: [], intolerances: ["wheat", "halal"], category: "Frühstück", tags: "Frühstück, Essen, Sonstige Tags", time: 20, difficulty: .medium)
    }
}
