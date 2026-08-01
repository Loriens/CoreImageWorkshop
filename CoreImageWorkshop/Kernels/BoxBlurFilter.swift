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
    
    override var outputImage: CIImage? {
        guard let input = inputImage else { return nil }
        return nil
    }
}
