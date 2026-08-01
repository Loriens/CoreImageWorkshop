//
//  FilterView.swift
//  CoreImageWorkshop
//
//  Created by Vladislav Markov on 27/03/2026.
//

import SwiftUI
import CoreImage

struct FilterView: View {
    let filter: FilterDefinition

    @State private var scalarValues: [String: Float] = [:]
    @State private var colorValues: [String: CIColor] = [:]
    @State private var vectorValues: [String: CIVector] = [:]
    @State private var filteredImage: UIImage?
    @State private var showingOriginal = false

    private let renderer = ImageRenderer.shared
    private let originalImage = UIImage(named: "sample")!

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                if let filteredImage {
                    Image(uiImage: showingOriginal ? originalImage : filteredImage)
                        .resizable()
                        .scaledToFit()
                        .onLongPressGesture(minimumDuration: .infinity, pressing: { pressing in
                            showingOriginal = pressing
                        }, perform: {})
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(radius: 4)
                        .padding(32)
                }

                VStack(spacing: 16) {
                    ForEach(filter.parameters) { param in
                        parameterView(for: param)
                            .padding(.horizontal)
                    }
                }
            }
        }
        .navigationTitle(filter.name)
        .onAppear {
            for param in filter.parameters {
                switch param.type {
                case .scalar(_, _, let defaultValue):
                    scalarValues[param.key] = defaultValue
                case .color(let defaultValue):
                    colorValues[param.key] = defaultValue
                case .vector(let defaultValue):
                    vectorValues[param.key] = defaultValue
                }
            }
            applyFilter()
        }
    }

    @ViewBuilder
    private func parameterView(for param: FilterParameter) -> some View {
        switch param.type {
        case .scalar(let min, let max, let defaultValue):
            VStack(alignment: .leading, spacing: 16) {
                Text("\(param.name): \(String(format: "%.2f", scalarValues[param.key] ?? defaultValue))")
                    .font(.caption)
                Slider(
                    value: scalarBinding(for: param.key, default: defaultValue),
                    in: min...max
                )
            }

        case .color(let defaultValue):
            ColorPicker(param.name, selection: colorBinding(for: param.key, default: defaultValue))
                .font(.caption)

        case .vector(let defaultValue):
            VStack(alignment: .leading) {
                Text(param.name)
                    .font(.caption)
                HStack {
                    Text("X")
                        .font(.caption2)
                    TextField("X", value: vectorComponentBinding(for: param.key, component: 0, default: defaultValue), format: .number)
                        .textFieldStyle(.roundedBorder)
                    Text("Y")
                        .font(.caption2)
                    TextField("Y", value: vectorComponentBinding(for: param.key, component: 1, default: defaultValue), format: .number)
                        .textFieldStyle(.roundedBorder)
                }
            }
        }
    }

    private func scalarBinding(for key: String, default defaultValue: Float) -> Binding<Float> {
        Binding(
            get: { scalarValues[key] ?? defaultValue },
            set: { newValue in
                scalarValues[key] = newValue
                applyFilter()
            }
        )
    }

    private func colorBinding(for key: String, default defaultValue: CIColor) -> Binding<Color> {
        Binding(
            get: {
                let ci = colorValues[key] ?? defaultValue
                return Color(red: Double(ci.red), green: Double(ci.green), blue: Double(ci.blue))
            },
            set: { newColor in
                let resolved = UIColor(newColor)
                var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
                resolved.getRed(&r, green: &g, blue: &b, alpha: &a)
                colorValues[key] = CIColor(red: r, green: g, blue: b)
                applyFilter()
            }
        )
    }

    private func vectorComponentBinding(for key: String, component: Int, default defaultValue: CIVector) -> Binding<Double> {
        Binding(
            get: {
                let vector = vectorValues[key] ?? defaultValue
                return component < vector.count ? Double(vector.value(at: component)) : 0
            },
            set: { newValue in
                let current = vectorValues[key] ?? defaultValue
                let x = component == 0 ? CGFloat(newValue) : current.value(at: 0)
                let y = component == 1 ? CGFloat(newValue) : (current.count > 1 ? current.value(at: 1) : 0)
                vectorValues[key] = CIVector(x: x, y: y)
                applyFilter()
            }
        )
    }

    private func applyFilter() {
        var params: [String: Any] = [:]
        for (key, value) in scalarValues { params[key] = value }
        for (key, value) in colorValues { params[key] = value }
        for (key, value) in vectorValues { params[key] = value }
        filteredImage = renderer.apply(inputImage: originalImage, filterName: filter.ciFilterName, parameters: params)
    }
}
