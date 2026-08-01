//
//  LipsBeautyFilterView.swift
//  CoreImageWorkshop
//
//  Created by Vladislav Markov on 08/04/2026.
//

import SwiftUI
import Vision
import CoreImage
import CoreImage.CIFilterBuiltins

struct LipsBeautyFilterView: View {
    @State private var resultImage: UIImage?
    @State private var lipsMask: CIImage?
    @State private var showingOriginal = false
    @State private var showingMask = false
    @State private var showingLandmarks = false
    @State private var maskImage: UIImage?
    @State private var landmarksImage: UIImage?
    @State private var useColorTint = true
    @State private var lipColor = Color(red: 0.76, green: 0.30, blue: 0.35)
    @State private var lipHue: Float = 0.0
    @State private var lipSaturation: Float = 1.8
    @State private var lipIntensity: Float = 0.6

    private let originalImage = UIImage(named: "face")!
    private let context = CIContext(options: [.useSoftwareRenderer: false])


    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                if let resultImage {
                    Image(uiImage: displayImage(result: resultImage))
                        .resizable()
                        .scaledToFit()
                        .onLongPressGesture(minimumDuration: .infinity, pressing: { pressing in
                            showingOriginal = pressing
                        }, perform: {})
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(radius: 4)
                        .padding(32)
                } else {
                    ProgressView("Detecting face landmarks...")
                        .padding(64)
                }

                VStack(spacing: 16) {
                    Picker("Mode", selection: $useColorTint) {
                        Text("Color Tint").tag(true)
                        Text("Hue/Saturation").tag(false)
                    }
                    .pickerStyle(.segmented)

                    if useColorTint {
                        ColorPicker("Lip Color", selection: $lipColor, supportsOpacity: false)
                            .font(.caption)
                    } else {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Lip Hue: \(String(format: "%.2f", lipHue))")
                                .font(.caption)
                            Slider(value: $lipHue, in: -Float.pi...Float.pi)
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Lip Saturation: \(String(format: "%.2f", lipSaturation))")
                                .font(.caption)
                            Slider(value: $lipSaturation, in: 0.5...4.0)
                        }
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Blend Intensity: \(String(format: "%.2f", lipIntensity))")
                            .font(.caption)
                        Slider(value: $lipIntensity, in: 0.0...1.0)
                    }
                }
                .padding(.horizontal)

                HStack(spacing: 12) {
                    Button(showingMask ? "Hide Mask" : "Show Mask") {
                        showingMask.toggle()
                        if showingMask { showingLandmarks = false }
                    }
                    .buttonStyle(.bordered)

                    Button(showingLandmarks ? "Hide Landmarks" : "Show Landmarks") {
                        showingLandmarks.toggle()
                        if showingLandmarks { showingMask = false }
                    }
                    .buttonStyle(.bordered)
                }

                Text("Long press to see original")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Lips Beauty Filter")
        .task {
            await detectLipsMask()
            applyFilter()
        }
        .onChange(of: useColorTint) { applyFilter() }
        .onChange(of: lipColor) { applyFilter() }
        .onChange(of: lipHue) { applyFilter() }
        .onChange(of: lipSaturation) { applyFilter() }
        .onChange(of: lipIntensity) { applyFilter() }
    }

    // MARK: - View Helpers

    private func displayImage(result: UIImage) -> UIImage {
        if showingMask { return maskImage ?? originalImage }
        if showingLandmarks { return landmarksImage ?? originalImage }
        if showingOriginal { return originalImage }
        return result
    }

    // MARK: - Face Detection

    private func detectLipsMask() async {}

    private func createLipsMask(from points: [CGPoint], pixelSize: CGSize) -> CIImage {
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1.0
        let renderer = UIGraphicsImageRenderer(size: pixelSize, format: format)

        let maskUIImage = renderer.image { ctx in
            ctx.cgContext.setFillColor(UIColor.black.cgColor)
            ctx.cgContext.fill(CGRect(origin: .zero, size: pixelSize))

            let path = CGMutablePath()
            path.move(to: points[0])
            for i in 1..<points.count {
                path.addLine(to: points[i])
            }
            path.closeSubpath()

            ctx.cgContext.setFillColor(UIColor.white.cgColor)
            ctx.cgContext.addPath(path)
            ctx.cgContext.fillPath()
        }

        let ciMask = CIImage(image: maskUIImage)!
        let blurred = ciMask
            .applyingGaussianBlur(sigma: 10.0)
            .cropped(to: ciMask.extent)
        return blurred
    }

    private func renderLandmarks(
        _ landmarks: FaceObservation.Landmarks2D,
        imageSize: CGSize
    ) -> UIImage {
        let regions: [(FaceObservation.Landmarks2D.Region, UIColor)] = [
            (landmarks.faceContour, .white),
            (landmarks.leftEye, .cyan),
            (landmarks.rightEye, .cyan),
            (landmarks.leftEyebrow, .yellow),
            (landmarks.rightEyebrow, .yellow),
            (landmarks.nose, .green),
            (landmarks.noseCrest, .green),
            (landmarks.outerLips, .red),
            (landmarks.innerLips, .orange),
            (landmarks.medianLine, .gray),
            (landmarks.leftPupil, .magenta),
            (landmarks.rightPupil, .magenta),
        ]

        let renderer = UIGraphicsImageRenderer(size: imageSize)
        return renderer.image { ctx in
            originalImage.draw(in: CGRect(origin: .zero, size: imageSize))

            for (region, color) in regions {
                let points = region.pointsInImageCoordinates(imageSize, origin: .upperLeft)
                guard points.count > 1 else {
                    // Single-point regions (pupils) — draw a dot
                    if let pt = points.first {
                        ctx.cgContext.setFillColor(color.cgColor)
                        ctx.cgContext.fillEllipse(in: CGRect(x: pt.x - 3, y: pt.y - 3, width: 6, height: 6))
                    }
                    continue
                }

                let path = CGMutablePath()
                path.move(to: points[0])
                for i in 1..<points.count {
                    path.addLine(to: points[i])
                }
                if region.pointsClassification == .closedPath {
                    path.closeSubpath()
                }

                ctx.cgContext.setStrokeColor(color.cgColor)
                ctx.cgContext.setLineWidth(4)
                ctx.cgContext.addPath(path)
                ctx.cgContext.strokePath()
            }
        }
    }

    // MARK: - Filter Pipeline

    private func applyFilter() {
        guard let mask = lipsMask else { return }

        let ciInput = CIImage(image: originalImage)!
        let output = applyLipColor(to: ciInput, mask: mask)

        if let cgResult = context.createCGImage(output, from: output.extent) {
            resultImage = UIImage(cgImage: cgResult)
        }
    }

    private func applyLipColor(to inputImage: CIImage, mask: CIImage) -> CIImage {
        let adjustedImage: CIImage
        if useColorTint {
            adjustedImage = applyColorTint(to: inputImage)
        } else {
            adjustedImage = applyHueSaturation(to: inputImage)
        }

        let blend = CIFilter.blendWithMask()
        blend.inputImage = adjustedImage
        blend.backgroundImage = inputImage
        blend.maskImage = mask

        guard let blended = blend.outputImage else { return inputImage }

        let mix = CIFilter.dissolveTransition()
        mix.inputImage = blended
        mix.targetImage = inputImage
        mix.time = 1.0 - lipIntensity

        return mix.outputImage ?? blended
    }

    private func applyColorTint(to inputImage: CIImage) -> CIImage {
        let resolved = UIColor(lipColor)
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        resolved.getRed(&r, green: &g, blue: &b, alpha: &a)

        let colorOverlay = CIImage(color: CIColor(red: r, green: g, blue: b))
            .cropped(to: inputImage.extent)

        // Soft-light blend preserves luminance from the original while tinting with the chosen color
        let softLight = CIFilter.softLightBlendMode()
        softLight.inputImage = colorOverlay
        softLight.backgroundImage = inputImage

        return softLight.outputImage ?? inputImage
    }

    private func applyHueSaturation(to inputImage: CIImage) -> CIImage {
        let hueAdjust = CIFilter.hueAdjust()
        hueAdjust.inputImage = inputImage
        hueAdjust.angle = lipHue

        let colorControls = CIFilter.colorControls()
        colorControls.inputImage = hueAdjust.outputImage
        colorControls.saturation = lipSaturation
        colorControls.brightness = 0.05
        colorControls.contrast = 1.1

        return colorControls.outputImage ?? inputImage
    }
}

#Preview {
    NavigationStack {
        LipsBeautyFilterView()
    }
}
