//
//  OnboardingView.swift
//  project_medusa
//
//  Created by zheer barzan on 12/2/25.
//


import RealityKit
import SwiftUI
import os

private let logger = Logger(subsystem: project_medusaApp.subsystem, category: "OnboardingView")

/// The view that shows the guidance text and tutorials on the review screen.
struct OnboardingView: View {
    @Environment(AppDataModel.self) var appModel
    private var stateMachine: OnboardingStateMachine
    @Binding private var showOnboardingView: Bool
    @State private var showShotLocations: Bool = false
    @Environment(\.colorScheme) private var colorScheme

    init(state: OnboardingState, showOnboardingView: Binding<Bool>) {
        stateMachine = OnboardingStateMachine(state)
        _showOnboardingView = showOnboardingView
    }

    var body: some View {
        GeometryReader { geometryReader in
            ZStack {
                Color(colorScheme == .light ? .white : .black).ignoresSafeArea()
                if let session = appModel.objectCaptureSession {
                    OnboardingTutorialView(session: session, onboardingStateMachine: stateMachine,
                                           showShotLocations: $showShotLocations,
                                           viewSize: geometryReader.size)
                    OnboardingButtonView(session: session,
                                         onboardingStateMachine: stateMachine,
                                         showOnboardingView: $showOnboardingView,
                                         showShotLocations: $showShotLocations)
                }
            }
            .allowsHitTesting(!isFinishingOrCompleted)
        }
    }

    private var isFinishingOrCompleted: Bool {
        guard let session = appModel.objectCaptureSession else { return true }
        return session.state == .finishing || session.state == .completed
    }
}
