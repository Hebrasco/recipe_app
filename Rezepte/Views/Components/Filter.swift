//
//  Filter.swift
//  Rezepte
//
//  Created by Daniel Bedrich on 30.03.20.
//  Copyright © 2020 Daniel Bedrich. All rights reserved.
//

import SwiftUI

struct Filter: View {
    let viewModel = FilterViewModel()
    
    var body: some View {
        VStack {
            Form {
                Section(header:
                Text("Filter").font(.largeTitle).bold(), content: {
                    ForEach(viewModel.intolerances, id: \.id) { intolerance in
                       Button(action: {
                           
                       }, label: {
                           IntoleranceItem(intolerance)
                       })
                   }
                })
               
            }
        }
    }
}


struct IntoleranceItem: View {
    @State var isToggleOn = false
    let intolerance: Recipe.Intolerance
    
    init(_ intolerance: Recipe.Intolerance) {
        self.intolerance = intolerance
    }
    
    var body: some View {
        HStack {
            Toggle(isOn: $isToggleOn, label: {
                Image(intolerance.image.rawValue)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 50)
                    .foregroundColor(.accentColor)
                Text(intolerance.type)
                    .foregroundColor(.primary)
            })
        }
    }
}

struct Filter_Previews: PreviewProvider {
    static var previews: some View {
        Filter()
    }
}
