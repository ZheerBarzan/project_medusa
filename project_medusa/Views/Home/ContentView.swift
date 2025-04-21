//
//  ContentView.swift
//  project_medusa
//
//  Created by zheer barzan on 12/2/25.
//

import SwiftUI // For building the user interface
import os // For logging and debugging

// Create a logger specific to this ContentView screen
private let logger = Logger(subsystem: project_medusaApp.subsystem, category: "ContentView")

/// The root of the SwiftUI View graph.
struct ContentView: View {
    // Access the shared app data model
    @Environment(AppDataModel.self) var appModel

    var body: some View {
        // Show the PrimaryView (most likely the camera or scanning view)
        PrimaryView()
            // When this screen appears, stop the phone from going to sleep
            .onAppear(perform: {
                UIApplication.shared.isIdleTimerDisabled = true
            })
            // When this screen disappears, allow the phone to sleep again
            .onDisappear(perform: {
                UIApplication.shared.isIdleTimerDisabled = false
            })
    }
}
