//
//  LaunchScreen.swift
//  project_medusa
//
//  Created by zheer barzan on 12/2/25.
//

import SwiftUI

struct LaunchScreen: View {
    @Environment(AppDataModel.self) var appModel
    
    @State private var isActive = false
    
    
    var body: some View {
        
        if isActive{
            HomeScreenView()
        }else{
            
            ZStack{
                Color.white
                    .ignoresSafeArea()
                Image("medusa")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
            }
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation{
                        isActive = true
                    }
                }
                
            }
        }
    }
}
