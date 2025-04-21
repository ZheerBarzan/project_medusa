//
//  SettingsView.swift
//  project_medusa
//
//  Created by zheer barzan on 12/2/25.
//

import SwiftUI // Import SwiftUI for building the user interface

struct SettingsView: View {
    // Access the shared app data (if needed)
    @Environment(AppDataModel.self) var appModel
    
    // Save and retrieve the user's preference to show the tutorial
    @AppStorage("show_tutorial") var enableTutorial: Bool = true

    // Save and retrieve the user's preference for dark mode
    @AppStorage("dark_mode") private var isDarkMode: Bool = false

    var body: some View {
        // Use a NavigationView to provide a navigation bar with a title
        NavigationView {
            // Stack the settings elements vertically with spacing between them
            VStack(alignment: .leading, spacing: 20) {
                
                // Toggle for Dark Mode
                Toggle("Dark Mode", isOn: $isDarkMode)
                    .padding() // Add spacing around the toggle
                    .background(Color.gray.opacity(0.4)) // Light gray background
                    .cornerRadius(10) // Rounded corners
                
                // Toggle for showing the tutorial
                Toggle("Show Tutorial", isOn: $enableTutorial)
                    .padding()
                    .background(Color.gray.opacity(0.4))
                    .cornerRadius(10)
                
                // Pushes content to the top of the screen, leaves space at the bottom
                Spacer()
            }
            .padding(20) // Add padding around the entire stack
            .navigationTitle("Settings") // Set the navigation bar title
        }
    }
}
