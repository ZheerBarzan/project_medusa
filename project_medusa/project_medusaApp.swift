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
    @AppStorage("dark_mode") private var isDarkMode: Bool = false



    var body: some Scene {
        WindowGroup {
            LaunchScreen()
                .environment(AppDataModel.instance)
                .preferredColorScheme(isDarkMode ? .dark : .light)

        }
    }
}
