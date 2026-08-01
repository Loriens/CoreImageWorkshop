//
//  CustomKernelView.swift
//  CoreImageWorkshop
//
//  Created by Vladislav Markov on 04/04/2026.
//

import SwiftUI
import CoreImage

struct CustomKernelView: View {
    @State private var selectedKernel = KernelType.color
    @State private var showingOriginal = false

    // Color kernel parameters
    @State private var threshold: Float = 0.5

    // Warp: Carnival Mirror parameters
    @State private var xAmplitude: Float = 20.0
    @State private var yAmplitude: Float = 20.0
    @State private var xWavelength: Float = 50.0
    @State private var yWavelength: Float = 50.0

    // General kernel parameters
    @State private var blurRadius: Float = 5.0

    private let renderer = ImageRenderer.shared
    private let originalImage = UIImage(named: "sample")!

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Picker("Kernel", selection: $selectedKernel) {
                    Text("Color").tag(KernelType.color)
                    Text("Warp").tag(KernelType.warp)
                    Text("General").tag(KernelType.general)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

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

                VStack(alignment: .leading, spacing: 16) {
                    switch selectedKernel {
                    case .color:
                        colorControls
                    case .warp:
                        warpControls
                    case .general:
                        generalControls
                    }
                }
                .padding(.horizontal)

                kernelDescription
                    .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle("Custom Kernels")
    }

    // MARK: - Computed filtered image

    private var filteredImage: UIImage? {
        switch selectedKernel {
        case .color:
            return renderer.apply(
                inputImage: originalImage,
                filterName: StarburstFilter.filterName,
                parameters: [
                    "inputThreshold": threshold as NSNumber
                ]
            )
        case .warp:
            return renderer.apply(
                inputImage: originalImage,
                filterName: CarnivalMirrorFilter.filterName,
                parameters: [
                    "inputXAmplitude": xAmplitude as NSNumber,
                    "inputYAmplitude": yAmplitude as NSNumber,
                    "inputXWavelength": xWavelength as NSNumber,
                    "inputYWavelength": yWavelength as NSNumber
                ]
            )
        case .general:
            return renderer.apply(
                inputImage: originalImage,
                filterName: BoxBlurFilter.filterName,
                parameters: [
                    "inputRadius": blurRadius as NSNumber
                ]
            )
        }
    }

    // MARK: - Controls

    @ViewBuilder
    private var colorControls: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Threshold Parameters").font(.headline)
            sliderRow("Threshold", value: $threshold, range: 0...1)
        }
    }
    
    @ViewBuilder
    private var warpControls: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Carnival Mirror Parameters").font(.headline)
            sliderRow("X Amplitude", value: $xAmplitude, range: 0...80)
            sliderRow("Y Amplitude", value: $yAmplitude, range: 0...80)
            sliderRow("X Wavelength", value: $xWavelength, range: 10...200)
            sliderRow("Y Wavelength", value: $yWavelength, range: 10...200)
        }
    }

    @ViewBuilder
    private var generalControls: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Box Blur Parameters").font(.headline)
            sliderRow("Radius", value: $blurRadius, range: 0...20)
        }
    }

    @ViewBuilder
    private func sliderRow(_ label: String, value: Binding<Float>, range: ClosedRange<Float>) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("\(label): \(String(format: "%.2f", value.wrappedValue))")
                .font(.caption)
            Slider(value: value, in: range)
        }
    }

    // MARK: - Description

    @ViewBuilder
    private var kernelDescription: some View {
        GroupBox {
            VStack(alignment: .leading, spacing: 8) {
                switch selectedKernel {
                case .color:
                    Text("CIColorKernel")
                        .font(.headline)
                    Text("Processes each pixel independently. Receives the pixel color as input and returns a new color. Cannot access neighboring pixels or coordinates.")
                        .font(.caption)
                    Text("This kernel computes luminance using BT.709 coefficients (R\u{00D7}0.2126 + G\u{00D7}0.7152 + B\u{00D7}0.0722) and outputs black or white based on whether the luma exceeds the threshold. Then CIMotionBlur creates starburst streaks composited over the original.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                case .warp:
                    Text("CIWarpKernel")
                        .font(.headline)
                    Text("Another warp kernel example. Like Ripple, it only remaps coordinates — no color changes, no multi-pixel sampling.")
                        .font(.caption)
                    Text("Uses the classic funhouse formula: x += sin(x / wavelength) * amplitude for each axis independently. Wavelength controls the wave period, amplitude controls displacement strength.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                case .general:
                    Text("CIKernel (General)")
                        .font(.headline)
                    Text("The most powerful kernel type. Can sample any pixel at any coordinate in the source image using a sampler. This allows blending multiple source samples into one output pixel.")
                        .font(.caption)
                    Text("This kernel averages all pixels in a square neighborhood around each pixel, producing a box blur. Only a general kernel can do this — it needs to read many source pixels via a sampler and combine them into one output.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    private enum KernelType {
        case color, warp, general
    }
}

#Preview {
    NavigationStack {
        CustomKernelView()
    }
}
