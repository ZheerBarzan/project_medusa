//
//  TutorialVideoView.swift
//  project_medusa
//
//  Created by zheer barzan on 12/2/25.
//

import SwiftUI

// View to play a video tutorial
struct TutorialVideoView: View {
    @Environment(AppDataModel.self) var appModel // Shared app data

    let url: URL // URL of the video to play
    let isInReviewSheet: Bool // Is this video inside a review sheet?

    @Environment(\.colorScheme) private var colorScheme // Light or dark mode

    var body: some View {
        VStack(spacing: 0) {
            // Video player with dynamic appearance
            PlayerView(
                url: url,
                isInverted: (colorScheme == .light && isInReviewSheet) ? true : false
            )

            // Add spacing if inside a review sheet
            if isInReviewSheet {
                Spacer(minLength: 28)
            }
        }
        .foregroundColor(.white) // Force text/controls to be white
    }
}
