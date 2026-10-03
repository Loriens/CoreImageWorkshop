//
//  LumaThresholdFilter.swift
//  CoreImageWorkshop
//
//  Created by Vladislav Markov on 04/04/2026.
//

import CoreImage

class LumaThresholdFilter: CIFilter {
    static let filterName = "LumaThreshold"

    @objc var inputImage: CIImage?
    @objc var inputThreshold: NSNumber = 0.5

    private static let kernel: CIColorKernel = {
        let url = Bundle.main.url(forResource: "CustomKernels.ci", withExtension: "metallib")!
        let data = try! Data(contentsOf: url)
        return try! CIColorKernel(functionName: "lumaThreshold", fromMetalLibraryData: data)
    }()

    override var outputImage: CIImage? {
        guard let input = inputImage else { return nil }
        return Self.kernel.apply(
            extent: input.extent,
            arguments: [input, inputThreshold]
        )
    }
}
