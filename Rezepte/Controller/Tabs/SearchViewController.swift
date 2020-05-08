//
//  SearchViewController.swift
//  Rezepte
//
//  Created by Daniel Bedrich on 13.02.20.
//  Copyright © 2020 Daniel Bedrich. All rights reserved.
//

import Foundation

final class SearchViewController: ObservableObject {
    @Published var searchText = ""
    @Published var filterViewModel = FilterController()    
}
