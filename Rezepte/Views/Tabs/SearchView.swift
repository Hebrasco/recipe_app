//
//  SearchView.swift
//  Rezepte
//
//  Created by Daniel Bedrich on 13.02.20.
//  Copyright © 2020 Daniel Bedrich. All rights reserved.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var viewModel = SearchViewModel()
    
    var body: some View {
        Text("Suche")
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
