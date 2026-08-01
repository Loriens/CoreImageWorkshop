//
//  ScaleHorizontalFilter.swift
//  CoreImageWorkshop
//
//  Created by Vladislav Markov on 04/04/2026.
//

import CoreImage

class ScaleHorizontalFilter: CIFilter {
    static let filterName = "ScaleHorizontal"

    @objc var inputImage: CIImage?
    @objc var inputScaleX: NSNumber = 1.0

    private static let kernel: CIWarpKernel = {
        let url = Bundle.main.url(forResource: "ScaleHorizontal.ci", withExtension: "metallib")!
        let data = try! Data(contentsOf: url)
        return try! CIWarpKernel(functionName: "scaleHorizontal", fromMetalLibraryData: data)
    }()

    override var outputImage: CIImage? {
        guard let input = inputImage else { return nil }
        
        let extent = CGRect(
            x: input.extent.origin.x,
            y: input.extent.origin.y,
            width: input.extent.width * CGFloat(inputScaleX.floatValue),
            height: input.extent.height
        )
        
        let result = Self.kernel.apply(
            extent: extent,
            roiCallback: { _, rect in
                return rect
            },
            image: input,
            arguments: [inputScaleX]
        )
        
        return result
    }
}
