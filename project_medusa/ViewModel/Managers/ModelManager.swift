//
//  ModelManager.swift
//  project_medusa
//
//  Created by zheer barzan on 21/4/25.
//

import Foundation
import SwiftUI

// A utility class to manage 3D model files
class ModelManager{
    
    static let sharedModel = ModelManager()
    
    private init(){
        
    }
    // Get all models from the app document directory
    func getAllModels() async -> [ModelObjectItem]{
        
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else{
            return []
        }
        
        do {
            let folderURLs = try FileManager.default.contentsOfDirectory(
                at: documentsDirectory,
                includingPropertiesForKeys: [.creationDateKey],
                options: []
            ).filter{ $0.hasDirectoryPath}
                .sorted(by: {
                    // Sort by creation date, newest first
                    let date1 = try? $0.resourceValues(forKeys: [.creationDateKey]).creationDate ?? Date()
                    let date2 = try? $1.resourceValues(forKeys: [.creationDateKey]).creationDate ?? Date()
                    
                    return date1 ?? Date() > date2 ?? Date()
                    
                })
            // Create models array
            var models: [ModelObjectItem] = []
            
            for folderURL in folderURLs {
                // Look for model file in the Models subfolder
                let modelFolder = folderURL.appendingPathComponent("Models")
                
                if FileManager.default.fileExists(atPath: modelFolder.path) {
                    let modelFiles = try? FileManager.default.contentsOfDirectory(
                        at: modelFolder,
                        includingPropertiesForKeys: nil,
                        options: []
                        
                    ).filter{ $0.pathExtension.lowercased() == "usdz" }
                    
                    if let modelFile = modelFiles?.first{
                        // Try to get creation date
                        let attributes = try? FileManager.default.attributesOfItem(atPath: folderURL.path)
                        let creationDate = attributes?[.creationDate] as? Date ?? Date()
                        
                        // Get thumbnail from first image
                        let imagesFolder = folderURL.appendingPathComponent(CaptureFolderManager.imagesFolderName)
                        let firstImage = try? FileManager.default.contentsOfDirectory(
                            at: imagesFolder,
                            includingPropertiesForKeys: nil,
                            options: [])
                            .filter { !$0.hasDirectoryPath }
                            .sorted(by: { $0.path < $1.path })
                            .first
                        
                        // create model Item
                        let newModel = ModelObjectItem(
                            id: folderURL.lastPathComponent,
                            name: folderURL.lastPathComponent,
                            url: modelFile,
                            thumbnailURL: firstImage,
                            creationDate: creationDate
                        )
                        models.append(newModel)
                        
                    }
                }
            }
            return models
        } catch {
            print("Error getting models: \(error)")
            return []
        }
        
    }
    // Rename a model (folder)
    func renameModel(at url: URL, to newName: String) async -> Bool {
        // Check for empty new name
        guard !newName.isEmpty else {
            print("Cannot rename: new name is empty")
            return false
        }
        
        let fileManager = FileManager.default
        
        // Get documents directory directly
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return false
        }
        
        // Get current folder name
        let currentFolderName = url.lastPathComponent
        
        // Build paths properly
        let originalPath = documentsDirectory.appendingPathComponent(currentFolderName)
        let newPath = documentsDirectory.appendingPathComponent(newName)
        
        print("Renaming from: \(originalPath.path)")
        print("Renaming to: \(newPath.path)")
        
        do {
            // Check if source exists and destination doesn't
            if fileManager.fileExists(atPath: originalPath.path) && !fileManager.fileExists(atPath: newPath.path) {
                try fileManager.moveItem(at: originalPath, to: newPath)
                print("SUCCESS: Renamed folder to \(newName)")
                return true
            } else {
                if !fileManager.fileExists(atPath: originalPath.path) {
                    print("Source path doesn't exist")
                }
                if fileManager.fileExists(atPath: newPath.path) {
                    print("Destination path already exists")
                }
                return false
            }
        } catch {
            print("Error renaming model: \(error)")
            return false
        }
    }
    
    // delete a model (folder)
    func deleteModel(at url: URL) async -> Bool {
        let fileManager = FileManager.default
        
        do{
            try fileManager.removeItem(at: url)
            return true
        } catch {
            print("Error deleting model: \(error)")
            return false
        }
    }
    
    
    // Export model to a different format
    func exportModel(at url: URL, to format: ModelConverter.ExportFormat) async -> URL? {
        do{
            // convert the model to the desired format
            let exportURL = try await ModelConverter.convert(from: url, to: format)
            return exportURL
        } catch {
            print("Error exporting model: \(error)")
            return nil
        }
    }
    // Create a thumbnail image
    func createThumbnail(from imageURL: URL, size: CGSize = CGSize(width: 300, height: 300)) async -> UIImage? {
        do{
            let imageData = try Data(contentsOf: imageURL)
            if let image = UIImage(data: imageData) {
                let format = UIGraphicsImageRendererFormat()
                format.scale = 1.0
                
                let renderer = UIGraphicsImageRenderer(size: size, format: format)
                
                let thumbnail = renderer.image { context in
                    image.draw(in: CGRect(origin: .zero, size: size))
                    
                }
                return thumbnail
            }
            return nil
        } catch {
            print("Error creating thumbnail: \(error)")
            return nil
        }
    }
}
