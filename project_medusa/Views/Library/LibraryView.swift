//
//  LibraryView.swift
//  project_medusa
//
//  Created by zheer barzan on 12/2/25.
//

import SwiftUI // Import SwiftUI to build the UI

struct LibraryView: View {
    // Access the shared app data model
    @Environment(AppDataModel.self) var appModel

    // A toggle state to show or hide captures (not currently used)
    @State var showCaputres: Bool = true

    var body: some View {
        // A navigation container that provides a title bar and navigation features
        NavigationView {
            // This is a custom grid view, likely showing the 3D model thumbnails
            GallaryGrid()
                // Set the title at the top of the screen
                .navigationTitle("Library")
        }
    }
}

// A preview provider so you can see this view in Xcode previews
#Preview {
    LibraryView()
}
