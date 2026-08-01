//
//  CarnivalMirrorFilter.swift
//  CoreImageWorkshop
//
//  Created by Vladislav Markov on 06/04/2026.
//

import CoreImage

class CarnivalMirrorFilter: CIFilter {
    static let filterName = "CarnivalMirror"
    
    @objc var inputImage: CIImage?
    @objc var inputXAmplitude: NSNumber = 20.0
    @objc var inputYAmplitude: NSNumber = 20.0
    @objc var inputXWavelength: NSNumber = 50.0
    @objc var inputYWavelength: NSNumber = 50.0
    
    private static let kernel: CIWarpKernel = {
        let url = Bundle.main.url(forResource: "CustomKernels.ci", withExtension: "metallib")!
        let data = try! Data(contentsOf: url)
        return try! CIWarpKernel(functionName: "carnivalMirror", fromMetalLibraryData: data)
    }()
    
    override var outputImage: CIImage? {
        guard let input = inputImage else { return nil }
        let amp = max(CGFloat(inputXAmplitude.floatValue), CGFloat(inputYAmplitude.floatValue))
        
        return Self.kernel.apply(
            extent: input.extent,
            roiCallback: { _, rect in
                return rect.insetBy(dx: -amp - 1, dy: -amp - 1)
            },
            image: input,
            arguments: [inputXAmplitude, inputYAmplitude, inputXWavelength, inputYWavelength]
        )
    }
}
