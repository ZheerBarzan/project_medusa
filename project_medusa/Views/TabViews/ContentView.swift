//
//  ContentView.swift
//  project_medusa
//
//  Created by zheer barzan on 12/2/25.
//

import SwiftUI
import os

private let logger = Logger(subsystem: project_medusaApp.subsystem, category: "ContentView")

/// The root of the SwiftUI View graph.
struct ContentView: View {
    @Environment(AppDataModel.self) var appModel

    var body: some View {
        
      
            
            PrimaryView()
                      .onAppear(perform: {
                          UIApplication.shared.isIdleTimerDisabled = true
                      })
                      .onDisappear(perform: {
                          UIApplication.shared.isIdleTimerDisabled = false
                      })
     
    }
}
