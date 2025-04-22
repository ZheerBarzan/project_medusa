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
    // In ModelManager.swift
    func renameModel(at url: URL, to newName: String) async -> Bool {
        let fileManager = FileManager.default
        
        // Get the parent directory
        let parentFolder = url.deletingLastPathComponent()
        
        // Create a new folder path with the new name
        let newFolderURL = parentFolder.appendingPathComponent(newName)
        
        do {
            // First check if destination already exists
            if fileManager.fileExists(atPath: newFolderURL.path) {
                // Can't rename to existing folder name
                return false
            }
            
            // Move the folder (rename)
            try fileManager.moveItem(at: url, to: newFolderURL)
            
            print("Successfully renamed folder from \(url.lastPathComponent) to \(newName)")
            return true
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
