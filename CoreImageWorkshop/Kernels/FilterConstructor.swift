//
//  FilterConstructor.swift
//  CoreImageWorkshop
//
//  Created by Vladislav Markov on 04/04/2026.
//

import CoreImage

final class FilterConstructor: NSObject, CIFilterConstructor {
    static let shared = FilterConstructor()

    func filter(withName name: String) -> CIFilter? {
        switch name {
        case LumaThresholdFilter.filterName:
            return LumaThresholdFilter()
        case CarnivalMirrorFilter.filterName:
            return CarnivalMirrorFilter()
        case StarburstFilter.filterName:
            return StarburstFilter()
        case ScaleHorizontalFilter.filterName:
            return ScaleHorizontalFilter()
        case BoxBlurFilter.filterName:
            return BoxBlurFilter()
        default:
            return nil
        }
    }

    static func registerAll() {
        CIFilter.registerName(
            LumaThresholdFilter.filterName,
            constructor: shared,
            classAttributes: [
                kCIAttributeFilterDisplayName: "Luminance Threshold",
                kCIAttributeFilterCategories: [kCICategoryColorEffect]
            ]
        )
        CIFilter.registerName(
            CarnivalMirrorFilter.filterName,
            constructor: shared,
            classAttributes: [
                kCIAttributeFilterDisplayName: "Carnival Mirror",
                kCIAttributeFilterCategories: [kCICategoryDistortionEffect]
            ]
        )
        CIFilter.registerName(
            StarburstFilter.filterName,
            constructor: shared,
            classAttributes: [
                kCIAttributeFilterDisplayName: "Starburst",
                kCIAttributeFilterCategories: [kCICategoryStylize]
            ]
        )
        CIFilter.registerName(
            ScaleHorizontalFilter.filterName,
            constructor: shared,
            classAttributes: [
                kCIAttributeFilterDisplayName: "Scale Horizontal",
                kCIAttributeFilterCategories: [kCICategoryGeometryAdjustment]
            ]
        )
        CIFilter.registerName(
            BoxBlurFilter.filterName,
            constructor: shared,
            classAttributes: [
                kCIAttributeFilterDisplayName: "Box Blur (Kernel)",
                kCIAttributeFilterCategories: [kCICategoryBlur]
            ]
        )
    }
}
