//
//  FilterCategory.swift
//  CoreImageWorkshop
//
//  Created by Vladislav Markov on 27/03/2026.
//

import CoreImage

enum FilterCategory: String, CaseIterable, Identifiable {
    case blur = "Blur"
    case colorAdjustment = "Color Adjustment"
    case colorEffect = "Color Effect"
    case sharpen = "Sharpen"
    case stylize = "Stylize"
    case distortion = "Distortion"
    case halftoneEffect = "Halftone Effect"
    case tileEffect = "Tile Effect"
    case geometryAdjustment = "Geometry Adjustment"

    var id: String { rawValue }

    var systemImage: String {
        switch self {
        case .blur: "drop.halffull"
        case .colorAdjustment: "slider.horizontal.3"
        case .colorEffect: "paintpalette"
        case .sharpen: "triangle"
        case .stylize: "sparkles"
        case .distortion: "wand.and.stars"
        case .halftoneEffect: "circle.grid.3x3"
        case .tileEffect: "square.grid.3x3"
        case .geometryAdjustment: "crop.rotate"
        }
    }

    var filters: [FilterDefinition] {
        switch self {
        case .blur:
            [
                FilterDefinition(
                    name: "Gaussian Blur",
                    ciFilterName: "CIGaussianBlur",
                    parameters: [
                        FilterParameter(name: "Radius", key: "inputRadius", type: .scalar(min: 0, max: 50, defaultValue: 10)),
                    ]
                ),
                FilterDefinition(
                    name: "Box Blur",
                    ciFilterName: "CIBoxBlur",
                    parameters: [
                        FilterParameter(name: "Radius", key: "inputRadius", type: .scalar(min: 0, max: 50, defaultValue: 10)),
                    ]
                ),
                FilterDefinition(
                    name: "Disc Blur",
                    ciFilterName: "CIDiscBlur",
                    parameters: [
                        FilterParameter(name: "Radius", key: "inputRadius", type: .scalar(min: 0, max: 50, defaultValue: 10)),
                    ]
                ),
                FilterDefinition(
                    name: "Motion Blur",
                    ciFilterName: "CIMotionBlur",
                    parameters: [
                        FilterParameter(name: "Radius", key: "inputRadius", type: .scalar(min: 0, max: 50, defaultValue: 20)),
                        FilterParameter(name: "Angle", key: "inputAngle", type: .scalar(min: -3.14, max: 3.14, defaultValue: 0)),
                    ]
                ),
                FilterDefinition(
                    name: "Zoom Blur",
                    ciFilterName: "CIZoomBlur",
                    parameters: [
                        FilterParameter(name: "Amount", key: "inputAmount", type: .scalar(min: 0, max: 50, defaultValue: 20)),
                    ]
                ),
                FilterDefinition(
                    name: "Noise Reduction",
                    ciFilterName: "CINoiseReduction",
                    parameters: [
                        FilterParameter(name: "Noise Level", key: "inputNoiseLevel", type: .scalar(min: 0, max: 0.1, defaultValue: 0.02)),
                        FilterParameter(name: "Sharpness", key: "inputSharpness", type: .scalar(min: 0, max: 2, defaultValue: 0.4)),
                    ]
                ),
            ]

        case .colorAdjustment:
            [
                FilterDefinition(
                    name: "Color Controls",
                    ciFilterName: "CIColorControls",
                    parameters: [
                        FilterParameter(name: "Saturation", key: "inputSaturation", type: .scalar(min: 0, max: 2, defaultValue: 1)),
                        FilterParameter(name: "Brightness", key: "inputBrightness", type: .scalar(min: -1, max: 1, defaultValue: 0)),
                        FilterParameter(name: "Contrast", key: "inputContrast", type: .scalar(min: 0, max: 4, defaultValue: 1)),
                    ]
                ),
                FilterDefinition(
                    name: "Exposure Adjust",
                    ciFilterName: "CIExposureAdjust",
                    parameters: [
                        FilterParameter(name: "EV", key: "inputEV", type: .scalar(min: -5, max: 5, defaultValue: 0)),
                    ]
                ),
                FilterDefinition(
                    name: "Gamma Adjust",
                    ciFilterName: "CIGammaAdjust",
                    parameters: [
                        FilterParameter(name: "Power", key: "inputPower", type: .scalar(min: 0.1, max: 3, defaultValue: 0.75)),
                    ]
                ),
                FilterDefinition(
                    name: "Hue Adjust",
                    ciFilterName: "CIHueAdjust",
                    parameters: [
                        FilterParameter(name: "Angle", key: "inputAngle", type: .scalar(min: -3.14, max: 3.14, defaultValue: 0)),
                    ]
                ),
                FilterDefinition(
                    name: "Vibrance",
                    ciFilterName: "CIVibrance",
                    parameters: [
                        FilterParameter(name: "Amount", key: "inputAmount", type: .scalar(min: -1, max: 1, defaultValue: 0)),
                    ]
                ),
                FilterDefinition(
                    name: "White Point Adjust",
                    ciFilterName: "CIWhitePointAdjust",
                    parameters: [
                        FilterParameter(name: "Color", key: "inputColor", type: .color(defaultValue: CIColor(red: 1, green: 1, blue: 1))),
                    ]
                ),
                FilterDefinition(
                    name: "Highlight Shadow Adjust",
                    ciFilterName: "CIHighlightShadowAdjust",
                    parameters: [
                        FilterParameter(name: "Highlight", key: "inputHighlightAmount", type: .scalar(min: 0, max: 1, defaultValue: 1)),
                        FilterParameter(name: "Shadow", key: "inputShadowAmount", type: .scalar(min: -1, max: 1, defaultValue: 0)),
                    ]
                ),
            ]

        case .colorEffect:
            [
                FilterDefinition(
                    name: "Color Monochrome",
                    ciFilterName: "CIColorMonochrome",
                    parameters: [
                        FilterParameter(name: "Color", key: "inputColor", type: .color(defaultValue: CIColor(red: 0.6, green: 0.45, blue: 0.3))),
                        FilterParameter(name: "Intensity", key: "inputIntensity", type: .scalar(min: 0, max: 1, defaultValue: 1)),
                    ]
                ),
                FilterDefinition(
                    name: "False Color",
                    ciFilterName: "CIFalseColor",
                    parameters: [
                        FilterParameter(name: "Color 0", key: "inputColor0", type: .color(defaultValue: CIColor(red: 0.3, green: 0, blue: 0))),
                        FilterParameter(name: "Color 1", key: "inputColor1", type: .color(defaultValue: CIColor(red: 1, green: 0.9, blue: 0.8))),
                    ]
                ),
                FilterDefinition(
                    name: "Sepia Tone",
                    ciFilterName: "CISepiaTone",
                    parameters: [
                        FilterParameter(name: "Intensity", key: "inputIntensity", type: .scalar(min: 0, max: 1, defaultValue: 1)),
                    ]
                ),
                FilterDefinition(
                    name: "Color Posterize",
                    ciFilterName: "CIColorPosterize",
                    parameters: [
                        FilterParameter(name: "Levels", key: "inputLevels", type: .scalar(min: 2, max: 30, defaultValue: 6)),
                    ]
                ),
                FilterDefinition(
                    name: "Color Invert",
                    ciFilterName: "CIColorInvert",
                    parameters: []
                ),
                FilterDefinition(
                    name: "Photo Effect Chrome",
                    ciFilterName: "CIPhotoEffectChrome",
                    parameters: []
                ),
                FilterDefinition(
                    name: "Photo Effect Fade",
                    ciFilterName: "CIPhotoEffectFade",
                    parameters: []
                ),
                FilterDefinition(
                    name: "Photo Effect Instant",
                    ciFilterName: "CIPhotoEffectInstant",
                    parameters: []
                ),
                FilterDefinition(
                    name: "Photo Effect Mono",
                    ciFilterName: "CIPhotoEffectMono",
                    parameters: []
                ),
                FilterDefinition(
                    name: "Photo Effect Noir",
                    ciFilterName: "CIPhotoEffectNoir",
                    parameters: []
                ),
                FilterDefinition(
                    name: "Photo Effect Tonal",
                    ciFilterName: "CIPhotoEffectTonal",
                    parameters: []
                ),
                FilterDefinition(
                    name: "Vignette",
                    ciFilterName: "CIVignette",
                    parameters: [
                        FilterParameter(name: "Radius", key: "inputRadius", type: .scalar(min: 0, max: 2, defaultValue: 1)),
                        FilterParameter(name: "Intensity", key: "inputIntensity", type: .scalar(min: -1, max: 1, defaultValue: 0)),
                    ]
                ),
            ]

        case .sharpen:
            [
                FilterDefinition(
                    name: "Sharpen Luminance",
                    ciFilterName: "CISharpenLuminance",
                    parameters: [
                        FilterParameter(name: "Sharpness", key: "inputSharpness", type: .scalar(min: 0, max: 2, defaultValue: 0.4)),
                    ]
                ),
                FilterDefinition(
                    name: "Unsharp Mask",
                    ciFilterName: "CIUnsharpMask",
                    parameters: [
                        FilterParameter(name: "Radius", key: "inputRadius", type: .scalar(min: 0, max: 50, defaultValue: 2.5)),
                        FilterParameter(name: "Intensity", key: "inputIntensity", type: .scalar(min: 0, max: 5, defaultValue: 0.5)),
                    ]
                ),
            ]

        case .stylize:
            [
                FilterDefinition(
                    name: "Bloom",
                    ciFilterName: "CIBloom",
                    parameters: [
                        FilterParameter(name: "Radius", key: "inputRadius", type: .scalar(min: 0, max: 50, defaultValue: 10)),
                        FilterParameter(name: "Intensity", key: "inputIntensity", type: .scalar(min: 0, max: 2, defaultValue: 0.5)),
                    ]
                ),
                FilterDefinition(
                    name: "Gloom",
                    ciFilterName: "CIGloom",
                    parameters: [
                        FilterParameter(name: "Radius", key: "inputRadius", type: .scalar(min: 0, max: 50, defaultValue: 10)),
                        FilterParameter(name: "Intensity", key: "inputIntensity", type: .scalar(min: 0, max: 2, defaultValue: 0.5)),
                    ]
                ),
                FilterDefinition(
                    name: "Pixellate",
                    ciFilterName: "CIPixellate",
                    parameters: [
                        FilterParameter(name: "Scale", key: "inputScale", type: .scalar(min: 1, max: 100, defaultValue: 8)),
                    ]
                ),
                FilterDefinition(
                    name: "Crystallize",
                    ciFilterName: "CICrystallize",
                    parameters: [
                        FilterParameter(name: "Radius", key: "inputRadius", type: .scalar(min: 1, max: 100, defaultValue: 20)),
                    ]
                ),
                FilterDefinition(
                    name: "Hexagonal Pixellate",
                    ciFilterName: "CIHexagonalPixellate",
                    parameters: [
                        FilterParameter(name: "Scale", key: "inputScale", type: .scalar(min: 1, max: 100, defaultValue: 8)),
                    ]
                ),
                FilterDefinition(
                    name: "Pointillize",
                    ciFilterName: "CIPointillize",
                    parameters: [
                        FilterParameter(name: "Radius", key: "inputRadius", type: .scalar(min: 1, max: 50, defaultValue: 5)),
                    ]
                ),
                FilterDefinition(
                    name: "Comic Effect",
                    ciFilterName: "CIComicEffect",
                    parameters: []
                ),
                FilterDefinition(
                    name: "Edges",
                    ciFilterName: "CIEdges",
                    parameters: [
                        FilterParameter(name: "Intensity", key: "inputIntensity", type: .scalar(min: 0, max: 10, defaultValue: 1)),
                    ]
                ),
                FilterDefinition(
                    name: "Edge Work",
                    ciFilterName: "CIEdgeWork",
                    parameters: [
                        FilterParameter(name: "Radius", key: "inputRadius", type: .scalar(min: 0, max: 20, defaultValue: 3)),
                    ]
                ),
                FilterDefinition(
                    name: "Line Overlay",
                    ciFilterName: "CILineOverlay",
                    parameters: [
                        FilterParameter(name: "Noise Level", key: "inputNRNoiseLevel", type: .scalar(min: 0, max: 0.2, defaultValue: 0.07)),
                        FilterParameter(name: "Sharpness", key: "inputNRSharpness", type: .scalar(min: 0, max: 2, defaultValue: 0.71)),
                    ]
                ),
            ]

        case .distortion:
            [
                FilterDefinition(
                    name: "Bump Distortion",
                    ciFilterName: "CIBumpDistortion",
                    parameters: [
                        FilterParameter(name: "Radius", key: "inputRadius", type: .scalar(min: 0, max: 600, defaultValue: 300)),
                        FilterParameter(name: "Scale", key: "inputScale", type: .scalar(min: -1, max: 1, defaultValue: 0.5)),
                    ]
                ),
                FilterDefinition(
                    name: "Pinch Distortion",
                    ciFilterName: "CIPinchDistortion",
                    parameters: [
                        FilterParameter(name: "Radius", key: "inputRadius", type: .scalar(min: 0, max: 1000, defaultValue: 300)),
                        FilterParameter(name: "Scale", key: "inputScale", type: .scalar(min: 0, max: 2, defaultValue: 0.5)),
                    ]
                ),
                FilterDefinition(
                    name: "Twirl Distortion",
                    ciFilterName: "CITwirlDistortion",
                    parameters: [
                        FilterParameter(name: "Radius", key: "inputRadius", type: .scalar(min: 0, max: 500, defaultValue: 300)),
                        FilterParameter(name: "Angle", key: "inputAngle", type: .scalar(min: -12.57, max: 12.57, defaultValue: 3.14)),
                    ]
                ),
                FilterDefinition(
                    name: "Vortex Distortion",
                    ciFilterName: "CIVortexDistortion",
                    parameters: [
                        FilterParameter(name: "Radius", key: "inputRadius", type: .scalar(min: 0, max: 800, defaultValue: 300)),
                        FilterParameter(name: "Angle", key: "inputAngle", type: .scalar(min: -94.25, max: 94.25, defaultValue: 56.55)),
                    ]
                ),
                FilterDefinition(
                    name: "Hole Distortion",
                    ciFilterName: "CIHoleDistortion",
                    parameters: [
                        FilterParameter(name: "Radius", key: "inputRadius", type: .scalar(min: 0.01, max: 300, defaultValue: 150)),
                    ]
                ),
                FilterDefinition(
                    name: "Circle Splash Distortion",
                    ciFilterName: "CICircleSplashDistortion",
                    parameters: [
                        FilterParameter(name: "Radius", key: "inputRadius", type: .scalar(min: 0, max: 600, defaultValue: 150)),
                    ]
                ),
                FilterDefinition(
                    name: "Light Tunnel",
                    ciFilterName: "CILightTunnel",
                    parameters: [
                        FilterParameter(name: "Rotation", key: "inputRotation", type: .scalar(min: 0, max: 6.28, defaultValue: 0)),
                        FilterParameter(name: "Radius", key: "inputRadius", type: .scalar(min: 1, max: 500, defaultValue: 100)),
                    ]
                ),
            ]

        case .halftoneEffect:
            [
                FilterDefinition(
                    name: "Dot Screen",
                    ciFilterName: "CIDotScreen",
                    parameters: [
                        FilterParameter(name: "Width", key: "inputWidth", type: .scalar(min: 1, max: 30, defaultValue: 6)),
                        FilterParameter(name: "Angle", key: "inputAngle", type: .scalar(min: -3.14, max: 3.14, defaultValue: 0)),
                        FilterParameter(name: "Sharpness", key: "inputSharpness", type: .scalar(min: 0, max: 1, defaultValue: 0.7)),
                    ]
                ),
                FilterDefinition(
                    name: "Circular Screen",
                    ciFilterName: "CICircularScreen",
                    parameters: [
                        FilterParameter(name: "Width", key: "inputWidth", type: .scalar(min: 1, max: 30, defaultValue: 6)),
                        FilterParameter(name: "Sharpness", key: "inputSharpness", type: .scalar(min: 0, max: 1, defaultValue: 0.7)),
                    ]
                ),
                FilterDefinition(
                    name: "Line Screen",
                    ciFilterName: "CILineScreen",
                    parameters: [
                        FilterParameter(name: "Width", key: "inputWidth", type: .scalar(min: 1, max: 30, defaultValue: 6)),
                        FilterParameter(name: "Angle", key: "inputAngle", type: .scalar(min: -3.14, max: 3.14, defaultValue: 0)),
                        FilterParameter(name: "Sharpness", key: "inputSharpness", type: .scalar(min: 0, max: 1, defaultValue: 0.7)),
                    ]
                ),
                FilterDefinition(
                    name: "Hatched Screen",
                    ciFilterName: "CIHatchedScreen",
                    parameters: [
                        FilterParameter(name: "Width", key: "inputWidth", type: .scalar(min: 1, max: 30, defaultValue: 6)),
                        FilterParameter(name: "Angle", key: "inputAngle", type: .scalar(min: -3.14, max: 3.14, defaultValue: 0)),
                        FilterParameter(name: "Sharpness", key: "inputSharpness", type: .scalar(min: 0, max: 1, defaultValue: 0.7)),
                    ]
                ),
                FilterDefinition(
                    name: "CMYK Halftone",
                    ciFilterName: "CICMYKHalftone",
                    parameters: [
                        FilterParameter(name: "Width", key: "inputWidth", type: .scalar(min: 1, max: 30, defaultValue: 6)),
                        FilterParameter(name: "Angle", key: "inputAngle", type: .scalar(min: -3.14, max: 3.14, defaultValue: 0)),
                        FilterParameter(name: "Sharpness", key: "inputSharpness", type: .scalar(min: 0, max: 1, defaultValue: 0.7)),
                    ]
                ),
            ]

        case .tileEffect:
            [
                FilterDefinition(
                    name: "Kaleidoscope",
                    ciFilterName: "CIKaleidoscope",
                    parameters: [
                        FilterParameter(name: "Count", key: "inputCount", type: .scalar(min: 1, max: 20, defaultValue: 6)),
                        FilterParameter(name: "Angle", key: "inputAngle", type: .scalar(min: -3.14, max: 3.14, defaultValue: 0)),
                    ]
                ),
                FilterDefinition(
                    name: "Triangle Kaleidoscope",
                    ciFilterName: "CITriangleKaleidoscope",
                    parameters: [
                        FilterParameter(name: "Size", key: "inputSize", type: .scalar(min: 1, max: 1000, defaultValue: 700)),
                        FilterParameter(name: "Rotation", key: "inputRotation", type: .scalar(min: -3.14, max: 3.14, defaultValue: 0)),
                        FilterParameter(name: "Decay", key: "inputDecay", type: .scalar(min: 0, max: 1, defaultValue: 0.85)),
                    ]
                ),
                FilterDefinition(
                    name: "Op Tile",
                    ciFilterName: "CIOpTile",
                    parameters: [
                        FilterParameter(name: "Scale", key: "inputScale", type: .scalar(min: 0.1, max: 3, defaultValue: 1)),
                        FilterParameter(name: "Angle", key: "inputAngle", type: .scalar(min: -3.14, max: 3.14, defaultValue: 0)),
                        FilterParameter(name: "Width", key: "inputWidth", type: .scalar(min: 1, max: 500, defaultValue: 100)),
                    ]
                ),
                FilterDefinition(
                    name: "Eightfold Reflected Tile",
                    ciFilterName: "CIEightfoldReflectedTile",
                    parameters: [
                        FilterParameter(name: "Width", key: "inputWidth", type: .scalar(min: 1, max: 500, defaultValue: 100)),
                        FilterParameter(name: "Angle", key: "inputAngle", type: .scalar(min: -3.14, max: 3.14, defaultValue: 0)),
                    ]
                ),
                FilterDefinition(
                    name: "Sixfold Reflected Tile",
                    ciFilterName: "CISixfoldReflectedTile",
                    parameters: [
                        FilterParameter(name: "Width", key: "inputWidth", type: .scalar(min: 1, max: 500, defaultValue: 100)),
                        FilterParameter(name: "Angle", key: "inputAngle", type: .scalar(min: -3.14, max: 3.14, defaultValue: 0)),
                    ]
                ),
                FilterDefinition(
                    name: "Twelvefold Reflected Tile",
                    ciFilterName: "CITwelvefoldReflectedTile",
                    parameters: [
                        FilterParameter(name: "Width", key: "inputWidth", type: .scalar(min: 1, max: 500, defaultValue: 100)),
                        FilterParameter(name: "Angle", key: "inputAngle", type: .scalar(min: -3.14, max: 3.14, defaultValue: 0)),
                    ]
                ),
            ]

        case .geometryAdjustment:
            [
                FilterDefinition(
                    name: "Straighten",
                    ciFilterName: "CIStraightenFilter",
                    parameters: [
                        FilterParameter(name: "Angle", key: "inputAngle", type: .scalar(min: -3.14, max: 3.14, defaultValue: 0)),
                    ]
                ),
                FilterDefinition(
                    name: "Lanczos Scale",
                    ciFilterName: "CILanczosScaleTransform",
                    parameters: [
                        FilterParameter(name: "Scale", key: "inputScale", type: .scalar(min: 0.1, max: 2, defaultValue: 1)),
                        FilterParameter(name: "Aspect Ratio", key: "inputAspectRatio", type: .scalar(min: 0.5, max: 2, defaultValue: 1)),
                    ]
                ),
            ]
        }
    }
}
