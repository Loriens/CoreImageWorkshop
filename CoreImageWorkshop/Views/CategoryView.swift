//
//  CategoryView.swift
//  CoreImageWorkshop
//
//  Created by Vladislav Markov on 27/03/2026.
//

import SwiftUI

struct CategoryView: View {
    let category: FilterCategory

    var body: some View {
        List(category.filters) { filter in
            NavigationLink(filter.name, destination: FilterView(filter: filter))
        }
        .navigationTitle(category.rawValue)
    }
}
