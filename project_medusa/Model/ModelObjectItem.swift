//
//  ModelObjectItem.swift
//  project_medusa
//
//  Created by zheer barzan on 21/4/25.
//

import Foundation

struct ModelObjectItem: Identifiable{
    
    let id: String
    var name: String
    let url: URL
    let thumbnailURL: URL?
    let creationDate: Date
    
    var formateDate: String{
        let formatter = DateFormatter()
        
        formatter.dateStyle = .medium
        return formatter.string(from: creationDate)
    }
    
}
