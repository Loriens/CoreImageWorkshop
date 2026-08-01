//
//  EyesBeautyFilterView.swift
//  CoreImageWorkshop
//
//  Created by Vladislav Markov on 10/04/2026.
//

import SwiftUI
import Vision
import CoreImage
import CoreImage.CIFilterBuiltins

struct EyesBeautyFilterView: View {
    @State private var resultImage: UIImage?
    @State private var showingOriginal = false
    @State private var showingLandmarks = false
    @State private var landmarksImage: UIImage?
    @State private var leftEyeCenter: CGPoint?
    @State private var rightEyeCenter: CGPoint?
    @State private var eyeRadius: CGFloat = 0
    @State private var eyeScale: Float = 0.0

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
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Eye Scale: \(String(format: "%.2f", eyeScale))")
                            .font(.caption)
                        Slider(value: $eyeScale, in: -1.0...1.0)
                    }
                }
                .padding(.horizontal)

                Button(showingLandmarks ? "Hide Landmarks" : "Show Landmarks") {
                    showingLandmarks.toggle()
                }
                .buttonStyle(.bordered)

                Text("Long press to see original")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Eyes Beauty Filter")
        .task {
            await detectEyes()
            applyFilter()
        }
        .onChange(of: eyeScale) { applyFilter() }
    }

    // MARK: - View Helpers

    private func displayImage(result: UIImage) -> UIImage {
        if showingLandmarks { return landmarksImage ?? originalImage }
        if showingOriginal { return originalImage }
        return result
    }

    // MARK: - Face Detection

    private func detectEyes() async {
        let request = DetectFaceLandmarksRequest()
        guard let ciImage = CIImage(image: originalImage),
              let observations = try? await request.perform(on: ciImage),
              let face = observations.first,
              let landmarks = face.landmarks else { return }

        let pixelSize = ciImage.extent.size

        let leftPoints = landmarks.leftEye.pointsInImageCoordinates(pixelSize, origin: .lowerLeft)
        let rightPoints = landmarks.rightEye.pointsInImageCoordinates(pixelSize, origin: .lowerLeft)

        leftEyeCenter = centroid(of: leftPoints)
        rightEyeCenter = centroid(of: rightPoints)
        eyeRadius = computeRadius(leftPoints: leftPoints, rightPoints: rightPoints)

        landmarksImage = renderLandmarks(landmarks, imageSize: originalImage.size)
    }

    private func centroid(of points: [CGPoint]) -> CGPoint {
        let sum = points.reduce(CGPoint.zero) { CGPoint(x: $0.x + $1.x, y: $0.y + $1.y) }
        return CGPoint(x: sum.x / CGFloat(points.count), y: sum.y / CGFloat(points.count))
    }

    private func computeRadius(leftPoints: [CGPoint], rightPoints: [CGPoint]) -> CGFloat {
        let allPoints = leftPoints + rightPoints
        let xs = allPoints.map(\.x)
        let ys = allPoints.map(\.y)
        let eyeWidth = (xs.max()! - xs.min()!) / 2
        let eyeHeight = ys.max()! - ys.min()!
        return max(eyeWidth, eyeHeight) * 0.7
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
        guard let leftCenter = leftEyeCenter,
              let rightCenter = rightEyeCenter else { return }

        let ciInput = CIImage(image: originalImage)!
        let output = applyBumpDistortion(to: ciInput, centers: [leftCenter, rightCenter])

        if let cgResult = context.createCGImage(output, from: output.extent) {
            resultImage = UIImage(cgImage: cgResult)
        }
    }

    private func applyBumpDistortion(to inputImage: CIImage, centers: [CGPoint]) -> CIImage {
        var result = inputImage
        for center in centers {
            let bump = CIFilter.bumpDistortion()
            bump.inputImage = result
            bump.center = center
            bump.radius = Float(eyeRadius)
            bump.scale = eyeScale * 0.3
            result = bump.outputImage?.cropped(to: inputImage.extent) ?? result
        }
        return result
    }
}

#Preview {
    NavigationStack {
        EyesBeautyFilterView()
    }
}
