//
//  HomeScreenView.swift
//  project_medusa
//
//  Created by zheer barzan on 12/2/25.
//

import SwiftUI // Import SwiftUI for building the user interface.

struct HomeScreenView: View {
    // Access the shared app data and functionality.
    @Environment(AppDataModel.self) var appModel
    
    // Check the current system color scheme (dark or light mode).
    @Environment(\.colorScheme) private var colorScheme

    // This code (commented out) would customize the tab bar's background color.
    // You could enable this if you want to make the tab bar black.
//    init() {
//           let tabBarAppearance = UITabBarAppearance()
//           tabBarAppearance.configureWithOpaqueBackground()
//           tabBarAppearance.backgroundColor = UIColor.black // Set the background color to black
//           UITabBar.appearance().standardAppearance = tabBarAppearance
//           UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
//       }

    var body: some View {
        ZStack {
            // Main tab view with 3 tabs: Library, Camera, and Settings
            TabView {
                // First tab: shows saved models or user library
                LibraryView()
                    .tabItem {
                        Image(systemName: "book") // Tab icon
                        Text("Library") // Tab label
                            .font(.system(size: 14, weight: .bold, design: .monospaced))
                    }.tag(0)

                // Second tab: main camera/scanning interface
                ContentView()
                    .tabItem {
                        Image(systemName: "camera")
                        Text("Camera")
                            .font(.system(size: 14, weight: .bold, design: .monospaced))
                    }.tag(1)

                // Third tab: settings screen
                SettingsView()
                    .tabItem {
                        Image(systemName: "gear")
                        Text("Settings")
                            .font(.system(size: 14, weight: .bold, design: .monospaced))
                    }.tag(2)
            }
            .padding(.top, 10) // Adds some spacing above the tab bar
            .accentColor(colorScheme == .dark ? .white : .black) // Changes selected tab color based on light/dark mode
        }
        .edgesIgnoringSafeArea(.top) // Lets content stretch to the top edge of the screen
    }
}
