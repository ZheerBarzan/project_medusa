//
//  LibraryView.swift
//  project_medusa
//
//  Created by zheer barzan on 12/2/25.
//

import SwiftUI

struct LibraryView: View {
    @Environment(AppDataModel.self) var appModel
    @State var showCaputres: Bool = true
    var body: some View {
        NavigationView{
            GallaryGrid()
                .navigationTitle("Library")
        }
    }
}

#Preview {
    LibraryView()
}
