//
//  GallaryGrid.swift
//  project_medusa
//
//  Created by zheer barzan on 13/2/25.
//

import SwiftUI

struct GallaryGrid: View {
    var body: some View {
        
            List{
                Text("hello")
                    .shadow(radius: 10)
                    .swipeActions(edge: .leading){
                        Button(role: .destructive){
                            
                        } label: {
                            Image(systemName: "trash")
                        }
                        
                        Button(){
                            
                        }label: {
                            Image(systemName: "gear")
                        }
                    }
                    .swipeActions(edge: .trailing) {
                        Button(){
                            
                        } label: {
                            Image(systemName: "share")
                        }
                    }
            }
        
    }
}

#Preview {
    GallaryGrid()
}
