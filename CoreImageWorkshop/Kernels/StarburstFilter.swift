//
//  StarburstFilter.swift
//  CoreImageWorkshop
//
//  Created by Vladislav Markov on 04/04/2026.
//

import CoreImage

class StarburstFilter: CIFilter {
    static let filterName = "Starburst"

    @objc var inputImage: CIImage?
    @objc var inputThreshold: NSNumber = 0.5
    @objc var inputRadius: NSNumber = 30.0
    @objc var inputAngle: NSNumber = NSNumber(value: Float.pi / 4 + Float.pi / 2)

    override var outputImage: CIImage? {
        guard let input = inputImage else { return nil }

        let thresholdFilter = LumaThresholdFilter()
        thresholdFilter.inputImage = input
        thresholdFilter.inputThreshold = inputThreshold
        
        guard let thresholded = thresholdFilter.outputImage else { return nil }

        let motionBlur = CIFilter.motionBlur()
        motionBlur.inputImage = thresholded
        motionBlur.radius = inputRadius.floatValue
        motionBlur.angle = inputAngle.floatValue
        
        guard let blurred = motionBlur.outputImage?.cropped(to: input.extent) else { return nil }
        
        let finalImage = blurred.applyingFilter(
            "CIAdditionCompositing",
            parameters: [kCIInputBackgroundImageKey: input]
        )

        return finalImage
    }
}
