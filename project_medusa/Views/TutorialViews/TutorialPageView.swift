//
//  TutorialPageView.swift
//  project_medusa
//
//  Created by zheer barzan on 12/2/25.
//

import SwiftUI // For building the UI

// A custom data model for each tutorial section
struct Section: Identifiable {
    let id = UUID() // Unique identifier
    let title: String // Section title
    let body: [String] // List of description points
    let symbol: String? // Optional SF Symbol icon name
    let symbolColor: Color? // Optional color for the icon
}

// View that shows a full tutorial page
struct TutorialPageView: View {
    let pageName: String // Title of the page
    let imageName: String // Image name (from assets)
    let imageCaption: String // Caption below the title
    let sections: [Section] // Array of tutorial sections

    var body: some View {
        VStack(alignment: .leading) {
            // Title
            Text(pageName)
                .foregroundColor(.primary)
                .font(.largeTitle)
                .bold()

            // Subtitle or caption
            Text(imageCaption)
                .foregroundColor(.secondary)

            // Centered image with size scaling based on device
            HStack {
                Spacer()
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaleEffect(UIDevice.current.userInterfaceIdiom == .pad ? 1.5 : 1.2)
                Spacer()
            }

            // List of tutorial sections
            SectionView(sections: sections)
        }
        .navigationBarTitle(pageName, displayMode: .inline)
    }
}

// Internal view for rendering the array of sections
private struct SectionView: View {
    let sections: [Section] // Input list of sections

    private let sectionHeight = 120.0 // Fixed height for each section block

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            ForEach(sections) { section in
                VStack(alignment: .leading) {
                    Divider() // Line to separate sections
                        .padding([.bottom, .trailing], 5.0)

                    // Title and optional symbol
                    HStack {
                        Text(section.title)
                            .bold()

                        Spacer()

                        if let symbol = section.symbol, let symbolColor = section.symbolColor {
                            Text(Image(systemName: symbol))
                                .bold()
                                .foregroundColor(symbolColor)
                        }
                    }

                    // Loop through each line in the section body
                    ForEach(section.body, id: \.self) { line in
                        Text(line)
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    Spacer()
                }
                .frame(height: sectionHeight) // Fixed section height
            }
        }

        Spacer() // Push content up
    }
}
