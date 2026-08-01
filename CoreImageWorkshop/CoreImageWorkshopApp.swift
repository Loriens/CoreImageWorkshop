//
//  CoreImageWorkshopApp.swift
//  CoreImageWorkshop
//
//  Created by Vladislav Markov on 10/04/2026.
//

import SwiftUI

@main
struct CoreImageWorkshopApp: App {
    init() {
        FilterConstructor.registerAll()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
