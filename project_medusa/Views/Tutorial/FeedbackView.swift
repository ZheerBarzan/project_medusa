//
//  FeedbackView.swift
//  project_medusa
//
//  Created by zheer barzan on 12/2/25.
//

import SwiftUI // For building the user interface
import os // For logging

// Logger specific to this FeedbackView
private let logger = Logger(subsystem: project_medusaApp.subsystem,
                            category: "FeedbackView")

// A view that shows temporary feedback messages to the user
struct FeedbackView: View {
    // List of timed messages (likely with expiration timing)
    var messageList: TimedMessageList

    var body: some View {
        VStack {
            // Show the message only if there is an active one
            if let activeMessage = messageList.activeMessage {
                Text("\(activeMessage.message)") // Display the message text
                    .font(.headline) // Use a headline font
                    .fontWeight(.bold) // Make the text bold
                    .foregroundColor(.white) // Set text color to white
                    .environment(\.colorScheme, .dark) // Force dark mode just for this
                    .transition(.opacity) // Add fade in/out animation
            }
        }
    }
}
