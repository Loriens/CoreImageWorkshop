//
//  ImageRenderer.swift
//  CoreImageWorkshop
//
//  Created by Vladislav Markov on 27/03/2026.
//

import CoreImage
import UIKit

final class ImageRenderer {
    static let shared = ImageRenderer()
    
    private var sampleImage: CIImage {
        let uiImage = UIImage(named: "sample")!
        let ciImage = CIImage(image: uiImage)!
        return ciImage
    }

    private init() {}

    private let context = CIContext(options: [
        .useSoftwareRenderer: false,
        .cacheIntermediates: false,
        .highQualityDownsample: true
    ])

    func apply(
        inputImage: UIImage,
        filterName: String,
        parameters: [String: Any]
    ) -> UIImage? {
        guard let filter = CIFilter(name: filterName) else { return nil }

        guard let ciInput = CIImage(image: inputImage) else { return nil }

        filter.setValue(ciInput, forKey: kCIInputImageKey)
        for (key, value) in parameters {
            filter.setValue(value, forKey: key)
        }

        if filter.inputKeys.contains(kCIInputCenterKey) && parameters[kCIInputCenterKey] == nil {
            let center = CIVector(x: ciInput.extent.midX, y: ciInput.extent.midY)
            filter.setValue(center, forKey: kCIInputCenterKey)
        }

        guard let output = filter.outputImage else { return nil }
        
        guard let cgImage = context.createCGImage(output, from: output.extent) else { return nil }
        
        print("CIContet Image Size - input:\(context.inputImageMaximumSize()), output:\(context.outputImageMaximumSize())")

        return UIImage(cgImage: cgImage)
    }
}
