//
//  Filter.swift
//  Rezepte
//
//  Created by Daniel Bedrich on 30.03.20.
//  Copyright © 2020 Daniel Bedrich. All rights reserved.
//

import SwiftUI

struct Filter: View {
    @ObservedObject var viewModel: FilterViewModel
    @Binding var filters: [FilterViewModel.Filter]
    @Binding var showSheet: Bool
    
    init(viewModel: FilterViewModel, filters: Binding<[FilterViewModel.Filter]>, showSheet: Binding<Bool>) {
        self.viewModel = viewModel
        self._filters = filters
        self._showSheet = showSheet
    }
    
    var body: some View {
        VStack {
            Form {
                Section(header: FilterHeader(showSheet: $showSheet),
                        footer: FilterFooter(viewModel: viewModel, filters: $filters, showSheet: $showSheet),
                        content: {
                            ForEach(filters.indices, id: \.self) { index in
                                return IntoleranceItem(self.$filters[index])
                        }
                })
            }
        }
    }
}

struct FilterHeader: View {
    @Binding var showSheet: Bool
    
    var body: some View {
        HStack {
            Text("Filter").font(.largeTitle).bold()
            Spacer()
            Button(action: {
                self.showSheet.toggle()
            }, label: {
                Text("Fertig").font(.callout)
            })
        }
    }
}

struct FilterFooter: View {
    @ObservedObject var viewModel: FilterViewModel
    @Binding var filters: [FilterViewModel.Filter]
    @Binding var showSheet: Bool
    
    var body: some View {
        Button(action: {
            for filter in self.filters {
                filter.isActive.wrappedValue = false
            }
            self.showSheet.toggle()
        }, label: {
            Text("Alle Filter zurücksetzen")
        })
    }
}

struct IntoleranceItem: View {
    @Binding var filter: FilterViewModel.Filter
    
    init(_ filter: Binding<FilterViewModel.Filter>) {
        self._filter = filter
    }
    
    var body: some View {
        HStack {
            Toggle(isOn: filter.isActive, label: {
                Image(filter.intolerance.image.rawValue)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 50)
                    .foregroundColor(.accentColor)
                Text(filter.intolerance.type)
                    .foregroundColor(.primary)
            })
        }
    }
}

struct Filter_Previews: PreviewProvider {
    static var previews: some View {
        Filter(viewModel: FilterViewModel(),
               filters: .constant([FilterViewModel.Filter(intolerance: Recipe.Intolerance(type: "Gluten", image: .gluten),
               isActive: .constant(false))]),
               showSheet: .constant(true))
    }
}
