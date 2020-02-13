//
//  RecipePlanView.swift
//  Rezepte
//
//  Created by Daniel Bedrich on 13.02.20.
//  Copyright © 2020 Daniel Bedrich. All rights reserved.
//

import SwiftUI

struct RecipePlanView: View {
    @ObservedObject var viewModel = RecipePlanViewModel()
    
    var body: some View {
        Text("Wochenplan")
    }
}

struct RecipePlanView_Previews: PreviewProvider {
    static var previews: some View {
        RecipePlanView()
    }
}
