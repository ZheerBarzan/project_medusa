// This file is the main entry point for the "project_medusa" app.
// It defines the app's structure and behavior when it starts.

import SwiftUI // Brings in the SwiftUI framework to build user interfaces.

@main // Marks this as the main entry point of the app.
struct project_medusaApp: App {
    // A unique identifier for the app, useful for logging or debugging.
    static let subsystem: String = "com.project-medusa"
    
    // A property to store the user's preference for dark mode.
    // The `@AppStorage` attribute automatically saves and retrieves this value.
    // This is like a switch that remembers the user's choice for dark mode, even after the app closes.
    @AppStorage("dark_mode") private var isDarkMode: Bool = false

    var body: some Scene {
        // Defines the main user interface of the app.
        WindowGroup {
            // The app starts by showing the `LaunchScreen` view.
            LaunchScreen()
                // Shares the `AppDataModel` instance across the app for global access.
                // This allows all parts of the app to use shared data and functions.
                .environment(AppDataModel.instance)
                // Sets the app's color scheme (dark or light mode) based on the user's preference.
                // If dark mode is true, show the app in dark mode. Otherwise, use light mode.
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}
