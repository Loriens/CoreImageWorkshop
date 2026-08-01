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
    
    override var outputImage: CIImage? {
        return nil
    }
}
