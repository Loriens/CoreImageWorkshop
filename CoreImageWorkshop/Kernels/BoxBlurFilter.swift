//
//  BoxBlurKernelFilter.swift
//  CoreImageWorkshop
//
//  Created by Vladislav Markov on 04/04/2026.
//

import CoreImage

class BoxBlurFilter: CIFilter {
    static let filterName = "BoxBlur"
    
    @objc var inputImage: CIImage?
    @objc var inputRadius: NSNumber = 5.0
    
    private static let kernel: CIKernel = {
        let url = Bundle.main.url(forResource: "CustomKernels.ci", withExtension: "metallib")!
        let data = try! Data(contentsOf: url)
        return try! CIKernel(functionName: "boxBlur", fromMetalLibraryData: data)
    }()
    
    override var outputImage: CIImage? {
        guard let input = inputImage else { return nil }
        
        let radius = CGFloat(inputRadius.floatValue)
        
        return Self.kernel.apply(
            extent: input.extent,
            roiCallback: { index, rect in
                input.extent.insetBy(dx: -radius - 1, dy: -radius - 1)
            },
            arguments: [input, inputRadius]
        )
    }
}
