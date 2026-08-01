//
//  UIImageDemoView.swift
//  CoreImageWorkshop
//
//  Created by Vladislav Markov on 04/04/2026.
//

import SwiftUI
import CoreImage
import QuartzCore

struct UIImageDemoView: View {
    @State private var viewModel = UIImageDemoViewModel()

    var body: some View {
        Image(uiImage: viewModel.outputImage)
            .resizable()
            .scaledToFit()
            .overlay(alignment: .topTrailing) {
                Text("\(viewModel.fps) FPS")
                    .font(.system(.body, design: .monospaced))
                    .padding(8)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8))
                    .padding()
            }
            .navigationTitle("UIImage Demo")
            .onAppear { viewModel.start() }
            .onDisappear { viewModel.stop() }
    }
}

@Observable
@MainActor
private final class UIImageDemoViewModel {
    var outputImage: UIImage = UIImage()
    var fps: Int = 0

    private let filterChain = TransitionFilterChain()
    private let ciContext = CIContext(options: [
        .useSoftwareRenderer: false,
        .highQualityDownsample: false,
        .cacheIntermediates: false
    ])
    private var displayLink: CADisplayLink?
    private var startTime: CFTimeInterval = 0
    private var lastFrameTime: CFTimeInterval = 0
    private var frameCount: Int = 0
    private var fpsAccumulator: CFTimeInterval = 0
    private let duration: CFTimeInterval = 3.0

    func start() {
        let link = CADisplayLink(target: DisplayLinkProxy { [weak self] link in
            self?.tick(link)
        }, selector: #selector(DisplayLinkProxy.handleTick))
        startTime = CACurrentMediaTime()
        link.add(to: .main, forMode: .common)
        displayLink = link
    }

    func stop() {
        displayLink?.invalidate()
        displayLink = nil
    }

    private func tick(_ link: CADisplayLink) {
        guard displayLink != nil else { return }
        let elapsed = link.timestamp - startTime
        let phase = elapsed.truncatingRemainder(dividingBy: duration * 2)
        let time = phase < duration ? phase / duration : 2.0 - phase / duration

        if let result = filterChain.apply(time: time),
           let cgImage = ciContext.createCGImage(result, from: result.extent) {
            outputImage = UIImage(cgImage: cgImage)
        }

        let now = CACurrentMediaTime()
        if lastFrameTime > 0 {
            fpsAccumulator += now - lastFrameTime
            frameCount += 1
            if fpsAccumulator >= 0.5 {
                fps = Int(Double(frameCount) / fpsAccumulator)
                frameCount = 0
                fpsAccumulator = 0
            }
        }
        lastFrameTime = now
    }
}

#Preview {
    UIImageDemoView()
}
