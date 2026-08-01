//
//  ContentView.swift
//  CoreImageWorkshop
//
//  Created by Vladislav Markov on 10/04/2026.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Workshop") {
                    NavigationLink(destination: DemoComparisonView()) {
                        Label("Rendering Comparison", systemImage: "square.split.1x2")
                    }
                    NavigationLink(destination: CustomKernelView()) {
                        Label("Custom Kernels", systemImage: "cpu")
                    }
                    NavigationLink(destination: RegionOfInterestView()) {
                        Label("Region of Interest", systemImage: "arrow.left.and.right")
                    }
                    NavigationLink(destination: LipsBeautyFilterView()) {
                        Label("Lips Beauty Filter", systemImage: "mouth")
                    }
                    NavigationLink(destination: EyesBeautyFilterView()) {
                        Label("Eyes Beauty Filter", systemImage: "eye")
                    }
                }
                
                Section("Filters") {
                    ForEach(FilterCategory.allCases) { category in
                        NavigationLink(destination: CategoryView(category: category)) {
                            Label(category.rawValue, systemImage: category.systemImage)
                        }
                    }
                }
            }
            .navigationTitle("Core Image Filters")
        }
    }
}

#Preview {
    ContentView()
}
