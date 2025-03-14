//
//  FeedbackView.swift
//  project_medusa
//
//  Created by zheer barzan on 12/2/25.
//


import SwiftUI
import os

private let logger = Logger(subsystem: project_medusaApp.subsystem,
                            category: "FeedbackView")

struct FeedbackView: View {
    var messageList: TimedMessageList

    var body: some View {
        VStack {
            if let activeMessage = messageList.activeMessage {
                Text("\(activeMessage.message)")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .environment(\.colorScheme, .dark)
                    .transition(.opacity)
            }
        }
    }
}
