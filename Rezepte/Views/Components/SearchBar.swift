//
//  SearchBar.swift
//  Rezepte
//
//  Created by Daniel Bedrich on 05.03.20.
//  Copyright © 2020 Daniel Bedrich. All rights reserved.
//

import SwiftUI

extension UIApplication {
    func endEditing(_ force: Bool) {
        self.windows
            .filter{$0.isKeyWindow}
            .first?
            .endEditing(force)
    }
}

struct ResignKeyboardOnDragGesture: ViewModifier {
    var gesture = DragGesture().onChanged { _ in
        UIApplication.shared.endEditing(true)
    }
    func body(content: Content) -> some View {
        return content.gesture(gesture)
    }
}

extension View {
    func resignKeyboardOnDragGesture() -> some View {
        return modifier(ResignKeyboardOnDragGesture())
    }
}

struct SearchBar: View {
    @State var showCancelButton = false
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 20))
                    .padding(.horizontal, 5)

                TextField("Rezepte durchsuchen", text: $searchText, onEditingChanged: { isEditing in
                    self.showCancelButton = true
                }, onCommit: {
                    print("onCommit")
                })
                .foregroundColor(.primary)
                .animation(.default)

                Button(action: {
                    self.searchText = String("")
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .opacity(searchText == "" ? 0.0 : 1.0)
                        .padding(.trailing, 5)
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
