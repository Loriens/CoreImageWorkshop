//
//  RegionOfInterestView.swift
//  CoreImageWorkshop
//
//  Created by Vladislav Markov on 04/04/2026.
//

import SwiftUI

struct RegionOfInterestView: View {
    @State private var scaleX: Float = 1.0
    @State private var filteredImage: UIImage?
    @State private var showingOriginal = false

    private let renderer = ImageRenderer.shared
    private let originalImage = UIImage(named: "big_sample")!

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                if let filtered = filteredImage {
                    Image(uiImage: showingOriginal ? originalImage : filtered)
                        .resizable()
                        .scaledToFit()
                        .onLongPressGesture(minimumDuration: .infinity, pressing: { pressing in
                            showingOriginal = pressing
                        }, perform: {})
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(radius: 4)
                        .padding(.horizontal)
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Scale Horizontal").font(.headline)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Scale X: \(String(format: "%.2f", scaleX))")
                            .font(.caption)
                        Slider(value: $scaleX, in: 1...3)
                        .onChange(of: scaleX) { applyFilter() }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle("Region of Interest")
        .onAppear { applyFilter() }
    }

    private func applyFilter() {
        filteredImage = renderer.apply(
            inputImage: originalImage,
            filterName: ScaleHorizontalFilter.filterName,
            parameters: [
                "inputScaleX": scaleX as NSNumber
            ]
        )
    }
}

#Preview {
    NavigationStack {
        RegionOfInterestView()
    }
}
