//
//  GallaryGrid.swift
//  project_medusa
//
//  Created by zheer barzan on 13/2/25.
//

import SwiftUI

struct GallaryGrid: View {
    @Environment(AppDataModel.self) var appModel
    
    var body: some View {
        
        if let captureFolderURLs{
            
            
            ScrollView{
                VStack{
                    
                    
                        ForEach(captureFolderURLs, id: \.self){ url in
                            let frameWidth = UIDevice.current.userInterfaceIdiom == .pad ? 100 : 115
                            NavigationLink(destination: ModelView(modelFile: url, endCaptureCallback: {[weak appModel] in
                                appModel?.endCapture()
                                
                            }).onAppear(perform: {
                                UIApplication.shared.isIdleTimerDisabled = false
                            })){
                                ThumbnailView(captureFolderURL: url, frameSize: CGSize(width: frameWidth, height: frameWidth + 70))
                            }
                    }
                }
            }
        }
        
    }
    func loadCaptures(){
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        _ = try? fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
        
    }
    private var captureFolderURLs: [URL]?{
                    guard let topLevelFolder = appModel.captureFolderManager?.appDocumentsFolder else {
                        return nil}
                    
                    let folderURLs = try? FileManager.default.contentsOfDirectory(
                        at: topLevelFolder,
                        includingPropertiesForKeys: nil, options: [])
                        .filter { $0.hasDirectoryPath }
                        .sorted(by: { $0.path > $1.path })
                    
                    guard let folderURLs else { return nil }
                    
                    return folderURLs
                }
                
}
