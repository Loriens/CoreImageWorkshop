//
//  TransitionFilterChain.swift
//  CoreImageWorkshop
//
//  Created by Vladislav Markov on 04/04/2026.
//

import CoreImage
import UIKit

final class TransitionFilterChain {
    private let sourceImage: CIImage
    private let targetImage: CIImage
    private let extent: CGRect

    private let dissolveFilter: CIFilter
    private let blurFilter1: CIFilter
    private let blurFilter2: CIFilter
    private let blurFilter3: CIFilter
    private let bloomFilter: CIFilter
    private let vortexFilter: CIFilter
    private let noiseFilter: CIFilter
    private let sharpenFilter: CIFilter
    private let crystallizeFilter: CIFilter

    init() {
        let sample = UIImage(named: "sample")!
        let face = UIImage(named: "face")!

        sourceImage = CIImage(image: sample)!
        let faceCI = CIImage(image: face)!

        let scaleX = sourceImage.extent.width / faceCI.extent.width
        let scaleY = sourceImage.extent.height / faceCI.extent.height
        targetImage = faceCI.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
        extent = sourceImage.extent

        dissolveFilter = CIFilter(name: "CIDissolveTransition")!
        dissolveFilter.setValue(sourceImage, forKey: kCIInputImageKey)
        dissolveFilter.setValue(targetImage, forKey: kCIInputTargetImageKey)

        let center = CIVector(x: extent.midX, y: extent.midY)

        blurFilter1 = CIFilter(name: "CIGaussianBlur")!
        blurFilter2 = CIFilter(name: "CIGaussianBlur")!
        blurFilter3 = CIFilter(name: "CIGaussianBlur")!
        bloomFilter = CIFilter(name: "CIBloom")!
        vortexFilter = CIFilter(name: "CIVortexDistortion")!
        vortexFilter.setValue(center, forKey: kCIInputCenterKey)
        noiseFilter = CIFilter(name: "CINoiseReduction")!
        sharpenFilter = CIFilter(name: "CIUnsharpMask")!
        crystallizeFilter = CIFilter(name: "CICrystallize")!
        crystallizeFilter.setValue(center, forKey: kCIInputCenterKey)
    }

    func apply(time: Double) -> CIImage? {
        print("Applying filters at time: \(time)")
        
        dissolveFilter.setValue(time, forKey: kCIInputTimeKey)
        guard let dissolved = dissolveFilter.outputImage else { return nil }

        blurFilter1.setValue(dissolved, forKey: kCIInputImageKey)
        blurFilter1.setValue(20.0 + time * 30.0, forKey: kCIInputRadiusKey)
        guard let blurred1 = blurFilter1.outputImage?.cropped(to: extent) else { return nil }

        noiseFilter.setValue(blurred1, forKey: kCIInputImageKey)
        noiseFilter.setValue(0.05, forKey: "inputNoiseLevel")
        noiseFilter.setValue(3.0 + time * 7.0, forKey: kCIInputSharpnessKey)
        guard let denoised = noiseFilter.outputImage?.cropped(to: extent) else { return nil }

        sharpenFilter.setValue(denoised, forKey: kCIInputImageKey)
        sharpenFilter.setValue(10.0, forKey: kCIInputRadiusKey)
        sharpenFilter.setValue(3.0, forKey: kCIInputIntensityKey)
        guard let sharpened = sharpenFilter.outputImage?.cropped(to: extent) else { return nil }

        blurFilter2.setValue(sharpened, forKey: kCIInputImageKey)
        blurFilter2.setValue(15.0 + time * 25.0, forKey: kCIInputRadiusKey)
        guard let blurred2 = blurFilter2.outputImage?.cropped(to: extent) else { return nil }

        bloomFilter.setValue(blurred2, forKey: kCIInputImageKey)
        bloomFilter.setValue(20.0, forKey: kCIInputRadiusKey)
        bloomFilter.setValue(1.0 + time, forKey: kCIInputIntensityKey)
        guard let bloomed = bloomFilter.outputImage?.cropped(to: extent) else { return nil }

        crystallizeFilter.setValue(bloomed, forKey: kCIInputImageKey)
        crystallizeFilter.setValue(5.0 + time * 15.0, forKey: kCIInputRadiusKey)
        guard let crystallized = crystallizeFilter.outputImage?.cropped(to: extent) else { return nil }

        blurFilter3.setValue(crystallized, forKey: kCIInputImageKey)
        blurFilter3.setValue(10.0 + time * 20.0, forKey: kCIInputRadiusKey)
        guard let blurred3 = blurFilter3.outputImage?.cropped(to: extent) else { return nil }

        vortexFilter.setValue(blurred3, forKey: kCIInputImageKey)
        vortexFilter.setValue(300.0 + time * 400.0, forKey: kCIInputRadiusKey)
        vortexFilter.setValue(time * .pi * 4, forKey: kCIInputAngleKey)

        return vortexFilter.outputImage?.cropped(to: extent)
    }
}
