//
//  DemoComparisonView.swift
//  CoreImageWorkshop
//
//  Created by Vladislav Markov on 04/04/2026.
//

import SwiftUI

struct DemoComparisonView: View {
    @State private var selectedMode = RenderMode.metal

    var body: some View {
        Group {
            switch selectedMode {
            case .metal:
                MetalDemoView()
            case .uiImage:
                UIImageDemoView()
            }
        }
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Picker("Renderer", selection: $selectedMode) {
                    Text("Metal").tag(RenderMode.metal)
                    Text("UIImage").tag(RenderMode.uiImage)
                }
                .pickerStyle(.segmented)
            }
        }
        .navigationTitle(selectedMode == .metal ? "Metal Demo" : "UIImage Demo")
    }

    private enum RenderMode {
        case metal, uiImage
    }
}

#Preview {
    NavigationStack {
        DemoComparisonView()
    }
}
