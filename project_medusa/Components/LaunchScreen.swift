//
//  LaunchScreen.swift
//  project_medusa
//
//  Created by zheer barzan on 12/2/25.
//

import SwiftUI // Brings in SwiftUI framework for building user interfaces.

struct LaunchScreen: View {
    // Access to the shared app model for global data/functions.
    @Environment(AppDataModel.self) var appModel
    
    // Controls whether to show the launch screen or the main home screen.
    @State private var isActive = false
    
    var body: some View {
        // If isActive is true, show the main screen. Otherwise, show the launch screen.
        if isActive {
            HomeScreenView()
        } else {
            ZStack {
                // White background that fills the entire screen.
                Color.white
                    .ignoresSafeArea()
                
                // Displays the Medusa logo image, centered and scaled.
                Image("medusa")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
            }
            // This runs when the view appears on screen.
            .onAppear {
                // Wait 2 seconds, then switch to the home screen with animation.
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        isActive = true
                    }
                }
            }
        }
    }
}
