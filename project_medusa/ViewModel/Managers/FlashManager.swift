//
//  FlashManager.swift
//  project_medusa
//
//  Created by zheer barzan on 27/5/25.
//

import AVFoundation
import os

private let logger = Logger(subsystem: project_medusaApp.subsystem, category: "FlashManager")


@Observable

class FlashManager {
    
    static let shared = FlashManager()
    
    private(set) var isFlashOn: Bool = false
    private(set) var isFlashAvailable: Bool = false
    
    private init() {
        checkFlashAvailability()
        
    }
    
    private func checkFlashAvailability() {
        guard let device = AVCaptureDevice.default(for: .video) else {
            isFlashAvailable = false
            return
        }
        isFlashAvailable = device.hasTorch
    }
    
    func toggleFlash() {
        guard isFlashAvailable else {
            logger.warning("Flash is not available on this device.")
            return
        }
        if isFlashOn {
            turnOffFlash()
        } else {
            turnOnFlash()
        }
        
    }
    func turnOnFlash() {
            guard isFlashAvailable else { return }
            
            guard let device = AVCaptureDevice.default(for: .video) else {
                logger.error("Could not access camera device")
                return
            }
            
            do {
                try device.lockForConfiguration()
                
                if device.torchMode == .off {
                    try device.setTorchModeOn(level: 1.0)
                    isFlashOn = true
                    logger.log("Flash turned ON")
                }
                
                device.unlockForConfiguration()
            } catch {
                logger.error("Failed to turn on flash: \(String(describing: error))")
            }
        }
        
        func turnOffFlash() {
            guard let device = AVCaptureDevice.default(for: .video) else {
                logger.error("Could not access camera device")
                return
            }
            
            do {
                try device.lockForConfiguration()
                
                if device.torchMode == .on {
                    device.torchMode = .off
                    isFlashOn = false
                    logger.log("Flash turned OFF")
                }
                
                device.unlockForConfiguration()
            } catch {
                logger.error("Failed to turn off flash: \(String(describing: error))")
            }
        }
        
        func forceFlashOff() {
            // This method is called when processing starts
            // It temporarily turns off flash regardless of user preference
            turnOffFlash()
        }
    
}
