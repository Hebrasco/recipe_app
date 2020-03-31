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
                Section(header: FilterHeader(),
                        footer: FilterFooter(),
                        content: {
                    ForEach(viewModel.intolerances, id: \.id) { intolerance in
                       IntoleranceItem(intolerance)
                   }
                })
            }
        }
    }
}

struct FilterHeader: View {
    var body: some View {
        HStack {
            Text("Filter").font(.largeTitle).bold()
            Spacer()
            Button(action: {
                
            }, label: {
                Text("Fertig").font(.callout)
            })
        }
    }
}

struct FilterFooter: View {
    var body: some View {
        Button(action: {
            
        }, label: {
            Text("Alle Filter zurücksetzen")
        })
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
