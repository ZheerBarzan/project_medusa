//
//  ModelConverter.swift
//  project_medusa
//
//  Created by zheer barzan on 21/4/25.
//
import Foundation
import SwiftUI
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
    
    static func convert(from sourceURL: URL, to format: ExportFormat) async throws -> URL{
        
    }
}
