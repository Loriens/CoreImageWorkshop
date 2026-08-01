//
//  MetalImageView.swift
//  CoreImageWorkshop
//
//  Created by Vladislav Markov on 04/04/2026.
//

import AVFoundation
import SwiftUI
import MetalKit
import CoreImage

struct MetalImageView: UIViewRepresentable {
    var ciImage: CIImage?

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> MTKView {
        let mtkView = MTKView()
        mtkView.device = context.coordinator.device
        mtkView.delegate = context.coordinator
        mtkView.framebufferOnly = false
        mtkView.isPaused = true
        mtkView.enableSetNeedsDisplay = true
        mtkView.contentScaleFactor = 1.0
        mtkView.backgroundColor = .clear
        return mtkView
    }

    func updateUIView(_ mtkView: MTKView, context: Context) {
        guard context.coordinator.ciImage != ciImage else { return }
        context.coordinator.ciImage = ciImage
        mtkView.setNeedsDisplay()
    }

    final class Coordinator: NSObject, MTKViewDelegate {
        let device: MTLDevice
        let commandQueue: MTLCommandQueue
        let ciContext: CIContext
        let colorSpace: CGColorSpace
        var ciImage: CIImage?

        override init() {
            device = MTLCreateSystemDefaultDevice()!
            commandQueue = device.makeCommandQueue()!
            colorSpace = CGColorSpaceCreateDeviceRGB()
            ciContext = CIContext(mtlDevice: device, options: [
                .useSoftwareRenderer: false,
                .highQualityDownsample: false,
                .cacheIntermediates: false
            ])
            
            super.init()
        }

        func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}

        func draw(in view: MTKView) {
            guard
                let ciImage,
                let drawable = view.currentDrawable,
                let commandBuffer = commandQueue.makeCommandBuffer()
            else { return }
            
            let drawableSize = view.drawableSize
            let bounds = CGRect(origin: .zero, size: drawableSize)
            let targetRect = AVMakeRect(aspectRatio: ciImage.extent.size, insideRect: bounds)
            
            let originX = targetRect.origin.x
            let originY = targetRect.origin.y
            let scaleX = targetRect.width / ciImage.extent.width
            let scaleY = targetRect.height / ciImage.extent.height
            let scale = min(scaleX, scaleY)
            let scaled = ciImage
                .transformed(by: CGAffineTransform(translationX: -ciImage.extent.origin.x, y: -ciImage.extent.origin.y))
                .transformed(by: CGAffineTransform(scaleX: scale, y: scale))
                .transformed(by: CGAffineTransform(translationX: originX, y: originY))
            
            ciContext.render(
                scaled,
                to: drawable.texture,
                commandBuffer: commandBuffer,
                bounds: bounds,
                colorSpace: colorSpace
            )

            commandBuffer.present(drawable)
            commandBuffer.commit()
            commandBuffer.waitUntilScheduled()
        }
    }
}
