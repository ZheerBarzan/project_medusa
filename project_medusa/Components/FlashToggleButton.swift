//
//  FlashToggleButton.swift
//  project_medusa
//
//  Created by zheer barzan on 27/5/25.
//


//
//  FlashToggleButton.swift
//  project_medusa
//
//  Created by zheer barzan on 27/5/25.
//

import SwiftUI
import os

private let logger = Logger(subsystem: project_medusaApp.subsystem, category: "FlashToggleButton")

struct FlashToggleButton: View {
    @Environment(AppDataModel.self) var appModel
    
    var body: some View {
        Button(action: {
            logger.log("Flash toggle button clicked!")
            appModel.toggleFlash()
        }, label: {
            VStack(spacing: 4) {
                Image(systemName: flashIconName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30 , height: 30)
                    .foregroundColor(.white)
                
                if UIDevice.current.userInterfaceIdiom == .pad {
                    Text(flashStatusText)
                        .font(.caption2)
                        .foregroundColor(.white)
                        .opacity(0.8)
                }
            }
            .padding(20)
            .contentShape(.rect)
        })
        .padding(-20)
        .opacity(shouldShowFlashButton ? 1.0 : 0.6)
        .disabled(!shouldShowFlashButton)
    }
    
    private var flashIconName: String {
        if !appModel.flashManager.isFlashAvailable {
            return "flashlight.slash.circle.fill"
        }
        
        return appModel.flashManager.isFlashOn ? "flashlight.on.circle" : "flashlight.slash.circle"
    }
    
    private var flashStatusText: String {
        if !appModel.flashManager.isFlashAvailable {
            return "Unavailable"
        }
        
        return appModel.flashManager.isFlashOn ? "On" : "Off"
    }
    
    private var shouldShowFlashButton: Bool {
        // Only show flash button during capture phases, not during processing
        guard appModel.flashManager.isFlashAvailable else { return false }
        
        switch appModel.state {
        case .capturing, .ready:
            return true
        case .prepareToReconstruct, .reconstructing, .viewing, .completed:
            return false
        default:
            return true
        }
    }
    
    struct LocalizedString {
        static let flashOn = NSLocalizedString(
            "Flash On (Object Capture)",
            bundle: Bundle.main,
            value: "Flash On",
            comment: "Title for flash on state.")
        
        static let flashOff = NSLocalizedString(
            "Flash Off (Object Capture)",
            bundle: Bundle.main,
            value: "Flash Off",
            comment: "Title for flash off state.")
        
        static let flashUnavailable = NSLocalizedString(
            "Flash Unavailable (Object Capture)",
            bundle: Bundle.main,
            value: "Flash Unavailable",
            comment: "Title when flash is not available on device.")
    }
}
