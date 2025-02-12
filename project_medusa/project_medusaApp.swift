//
//  project_medusaApp.swift
//  project_medusa
//
//  Created by zheer barzan on 12/2/25.
//

import SwiftUI

@main
struct project_medusaApp: App {
    
    static let subsystem: String = "com.project-medusa"


    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(AppDataModel.instance)
        }
    }
}
