//
//  Category.swift
//  Rezepte
//
//  Created by Daniel Bedrich on 18.02.20.
//  Copyright © 2020 Daniel Bedrich. All rights reserved.
//

import SwiftUI

struct Category: View {
    let name: String
    let image: String
    let destination: AnyView
    
    var body: some View {
        NavigationLink(
            destination: destination,
            label: {
                VStack {
                Image(image)
                    .resizable()
                    .frame(width: 100, height: 100)
                Text(name)
                    .foregroundColor(.primary)
                }
            }
        )
    }
}

struct Category_Previews: PreviewProvider {
    static var previews: some View {
        Category(name: "Frühstück",
                 image: "breakfast",
                 destination: AnyView(BreakfastView()))
    }
}
