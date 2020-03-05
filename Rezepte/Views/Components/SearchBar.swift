//
//  SearchBar.swift
//  Rezepte
//
//  Created by Daniel Bedrich on 05.03.20.
//  Copyright © 2020 Daniel Bedrich. All rights reserved.
//

import SwiftUI

struct SearchBar: View {
//    var searchText: Binding<String>
    @State var showCancelButton = false
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")

                TextField("search", text: $searchText, onEditingChanged: { isEditing in
                    self.showCancelButton.toggle()
                }, onCommit: {
                    print("onCommit")
                })
                .foregroundColor(.primary)
                .animation(.default)

                Button(action: {
                    self.searchText = String("")
                }) {
                    Image(systemName: "xmark.circle.fill").opacity(searchText == "" ? 0.0 : 1.0)
                }
            }
            .padding(.horizontal, 6)
            .padding(.vertical, 8)
            .foregroundColor(.secondary)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10.0)

            if showCancelButton {
                Button("Abbrechen") {
                        UIApplication.shared.endEditing(true)
                        self.searchText = ""
                        self.showCancelButton = false
                }
                .foregroundColor(.accentColor)
            }
        }
        .animation(.spring(response: 0.5, dampingFraction: 0.7, blendDuration: 1))
        .padding(.horizontal)
        //                .navigationBarHidden(showCancelButton)//.animation(.default) // animation does not work properly
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(searchText: .constant("Avocado"))
    }
}
