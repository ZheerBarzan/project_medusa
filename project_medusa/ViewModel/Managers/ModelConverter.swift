//
//  ModelConverter.swift
//  project_medusa
//
//  Created by zheer barzan on 21/4/25.
//
import Foundation
import SwiftUI
import SceneKit
import ModelIO

// A utility class for converting 3D models between formats
class ModelConverter{
    enum ConversionError: Error {
        case failedToLoadModel
        case failedToExport
        case unsupportedFormat
        
    }
    enum ExportFormat: String {
        case obj
        case usdz
        case fbx
        
        var fileExtension: String {
            return self.rawValue
        }
        
    }
    
    // Convert a model from one format to another

    static func convert(from sourceURL: URL, to format: ExportFormat) async throws -> URL{
        // Create a scene from the source file
        let scene: SCNScene
        
        do{
            scene = try SCNScene(url: sourceURL, options: nil)
        } catch {
            throw ConversionError.failedToLoadModel
        }
        
        // Create a temporary file URL for the exported model
        let tempDirectory = FileManager.default.temporaryDirectory
        let filename = "\(UUID().uuidString).\(format.fileExtension)"
        let outputURL = tempDirectory.appendingPathComponent(filename)
        
        // Different export methods for different formats
        switch format {
        case .obj:
            return try await exportAsObj(scene: scene, to: outputURL)
        case .usdz:
            return sourceURL
        case .fbx:
            throw ConversionError.unsupportedFormat
        }
    }
    
    // Export to OBJ format
        private static func exportAsObj(scene: SCNScene, to outputURL: URL) async throws -> URL {
            // Write to OBJ format
            if SCNScene.canExport(to: "obj") {
                let options: [SCNSceneExportOption: Any] = [:]
                let success = scene.write(to: outputURL, options: options, delegate: nil, progressHandler: nil)
                
                if success {
                    return outputURL
                } else {
                    throw ConversionError.failedToExport
                }
            } else {
                throw ConversionError.unsupportedFormat
            }
        }

    // Helper method to copy a model to Documents directory with a new name
        static func saveModelCopy(from sourceURL: URL, withName name: String) throws -> URL {
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let newFolderURL = documentsDirectory.appendingPathComponent(name)
            
            // Create a new directory for the model
            try FileManager.default.createDirectory(at: newFolderURL, withIntermediateDirectories: true, attributes: nil)
            
            // Copy the model file
            let filename = sourceURL.lastPathComponent
            let destinationURL = newFolderURL.appendingPathComponent(filename)
            
            try FileManager.default.copyItem(at: sourceURL, to: destinationURL)
            
            return destinationURL
        }
}
