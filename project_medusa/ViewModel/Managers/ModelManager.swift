//
//  ModelManager.swift
//  project_medusa
//
//  Created by zheer barzan on 21/4/25.
//

import Foundation
import SwiftUI

class ModelManager{
    
    static let sharedModel = ModelManager()
    
    private init(){
        
    }
    
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
                    let date1 = try? $0.resourceValues(forKeys: [.creationDateKey]).creationDate ?? Date()
                    let date2 = try? $1.resourceValues(forKeys: [.creationDateKey]).creationDate ?? Date()
                    
                    return date1 ?? Date() > date2 ?? Date()

                })
            
            
        }
        
    }
}
