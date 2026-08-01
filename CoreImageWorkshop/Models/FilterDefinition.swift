//
//  FilterDefinition.swift
//  CoreImageWorkshop
//
//  Created by Vladislav Markov on 27/03/2026.
//

import CoreImage

enum FilterParameterType {
    case scalar(min: Float, max: Float, defaultValue: Float)
    case color(defaultValue: CIColor)
    case vector(defaultValue: CIVector)
}

struct FilterParameter: Identifiable {
    let id = UUID()
    let name: String
    let key: String
    let type: FilterParameterType
}

struct FilterDefinition: Identifiable {
    let id = UUID()
    let name: String
    let ciFilterName: String
    let parameters: [FilterParameter]
}
