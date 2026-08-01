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
            ciContext = CIContext()
            
            super.init()
        }

        func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}

        func draw(in view: MTKView) {
            guard
                let ciImage,
                let drawable = view.currentDrawable,
                let commandBuffer = commandQueue.makeCommandBuffer()
            else { return }

            commandBuffer.present(drawable)
            commandBuffer.commit()
            commandBuffer.waitUntilScheduled()
        }
    }
}
