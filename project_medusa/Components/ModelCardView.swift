//
//  ModelCardView.swift
//  project_medusa
//
//  Created by zheer barzan on 23/4/25.
//


import SwiftUI

struct ModelCardView: View {
    let model: ModelObjectItem
    @State private var thumbnail: Image? = nil
    @State private var isLoadingThumbnail = true
    
    var body: some View {
        VStack(alignment: .leading) {
            // Thumbnail image
            ZStack {
                if let thumbnail = thumbnail {
                    thumbnail
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                        .clipped()

                        
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 200)
                        .cornerRadius(12)
                        .overlay {
                            if isLoadingThumbnail {
                                ProgressView()
                            } else {
                                Image(systemName: "cube.transparent")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.gray)
                            }
                        }
                }
                
                // 3D icon in the corner
                VStack {
                    HStack {
                        Spacer()
                        Image(systemName: "cube.transparent.fill")
                            .padding(8)
                            .background(.ultraThinMaterial)
                            .cornerRadius(8)
                            .padding(12)
                    }
                    Spacer()
                }
            }
            
            // Model info
            VStack(alignment: .leading, spacing: 7) {
                Text(model.name)
                    .font(.system(size: 20, weight: .medium, design: .monospaced))
                    .lineLimit(1)
                
                Text(model.formateDate)
                    .font(.system(size: 15, weight: .light, design: .monospaced))
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 10)
        }
        .background(Color(uiColor: .systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
        
        .task {
            await loadThumbnail()
        }
    }
    
    private func loadThumbnail() async {
        guard let thumbnailURL = model.thumbnailURL else {
            isLoadingThumbnail = false
            return
        }
        
        do {
            let imageData = try Data(contentsOf: thumbnailURL)
            if let uiImage = UIImage(data: imageData) {
                await MainActor.run {
                    self.thumbnail = Image(uiImage: uiImage)
                    self.isLoadingThumbnail = false
                }
            } else {
                await MainActor.run {
                    self.isLoadingThumbnail = false
                }
            }
        } catch {
            print("Failed to load thumbnail: \(error)")
            await MainActor.run {
                self.isLoadingThumbnail = false
            }
        }
    }
}


