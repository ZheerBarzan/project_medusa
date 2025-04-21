//
//  CapturePrimaryView.swift
//  project_medusa
//
//  Created by zheer barzan on 12/2/25.
//


import RealityKit
import SwiftUI
import os

private let logger = Logger(subsystem: project_medusaApp.subsystem, category: "CapturePrimaryView")

struct CapturePrimaryView: View {
    @Environment(AppDataModel.self) var appModel
    var session: ObjectCaptureSession

    var body: some View {
        ZStack {
            ObjectCaptureView(session: session,
                              cameraFeedOverlay: { GradientBackground() })
            .hideObjectReticle(appModel.captureMode == .scene)
            .blur(radius: appModel.showOverlaySheets ? 45 : 0)
            .transition(.opacity)

            CaptureOverlayView(session: session)
        }
        .onAppear(perform: {
            UIApplication.shared.isIdleTimerDisabled = true
        })
        .id(session.id)
    }
}

private struct GradientBackground: View {
    private let gradient = LinearGradient(
        colors: [.black.opacity(0.4), .clear],
        startPoint: .top,
        endPoint: .bottom
    )
    private let frameHeight: CGFloat = 300

    var body: some View {
        VStack {
            gradient
                .frame(height: frameHeight)

            Spacer()

            gradient
                .rotation3DEffect(Angle(degrees: 180), axis: (x: 1, y: 0, z: 0))
                .frame(height: frameHeight)
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
    }
}

