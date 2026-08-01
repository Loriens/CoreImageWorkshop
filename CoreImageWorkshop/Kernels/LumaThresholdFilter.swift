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

    override var outputImage: CIImage? {
        return nil
    }
}
