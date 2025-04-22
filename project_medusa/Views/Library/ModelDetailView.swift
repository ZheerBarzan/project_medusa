//
//  ModelDetailView.swift
//  project_medusa
//
//  Created by zheer barzan on 23/4/25.
//


import SwiftUI
import SceneKit
import QuickLook
import ARKit

struct ModelDetailView: View {
    @Environment(AppDataModel.self) var appModel

    let model: ModelObjectItem
    let onDismiss: () -> Void
    
    @State private var scale: Float = 1.0
    @State private var autoRotate: Bool = false
    @State private var showingExportOptions = false
    @State private var exportFormat: ExportFormat = .usdz
    @State private var showingARView = false

    
    enum ExportFormat: String, CaseIterable, Identifiable {
        case obj = "OBJ"
        case usdz = "USDZ"
        case fbx = "FBX"
        
        var id: String { self.rawValue }
        
        var fileExtension: String {
            switch self {
            case .obj: return "obj"
            case .usdz: return "usdz"
            case .fbx: return "fbx"
            }
        }
    }
    
    var body: some View {
        ZStack {
            // 3D model view using SceneKit
            SceneKitModelView(url: model.url, scale: scale, autoRotate: autoRotate)
                .edgesIgnoringSafeArea(.all)
            
            // Top controls
            VStack {
                HStack {
                    Button(action: onDismiss) {
                        Image(systemName: "xmark")
                            .padding(12)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    Button(action: {
                        showingARView = true
                    }) {
                        VStack {
                            Image(systemName: "arkit")
                                .font(.title2)
                            Text("View in AR")
                                .font(.caption)
                        }
                        .padding(12)
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                    }
                    .sheet(isPresented: $showingARView) {
                        ModelView(modelFile: model.url, endCaptureCallback: { [weak appModel] in
                            appModel?.endCapture()
                        })
                        .onAppear(perform: {
                            UIApplication.shared.isIdleTimerDisabled = false
                        })
                    }
                    Spacer()
                    
                    Button(action: {
                        showingExportOptions = true
                    }) {
                        Image(systemName: "square.and.arrow.up")
                            .padding(12)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                }
                .padding()
                
                Spacer()
                
                // Bottom controls for manipulating the model
                VStack {
                    Text(model.name)
                        .font(.headline)
                        .padding(8)
                        .background(.ultraThinMaterial)
                        .cornerRadius(8)
                    
                    HStack(spacing: 30) {
                        // Reset button
                        Button(action: {
                            withAnimation {
                                scale = 1.0
                                autoRotate = false
                            }
                        }) {
                            VStack {
                                Image(systemName: "arrow.counterclockwise")
                                    .font(.title2)
                                Text("Reset")
                                    .font(.caption)
                            }
                            .padding(12)
                            .background(.ultraThinMaterial)
                            .cornerRadius(12)
                        }
                        
                        // Scale controls
                        VStack {
                            Text("Scale")
                                .font(.caption)
                            
                            HStack {
                                Button(action: {
                                    withAnimation {
                                        scale = max(0.5, scale - 0.1)
                                    }
                                }) {
                                    Image(systemName: "minus")
                                }
                                
                                Text(String(format: "%.1f", scale))
                                    .frame(width: 40)
                                
                                Button(action: {
                                    withAnimation {
                                        scale = min(2.0, scale + 0.1)
                                    }
                                }) {
                                    Image(systemName: "plus")
                                }
                            }
                        }
                        .padding(12)
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                        
                        // Auto-rotate toggle
                        Button(action: {
                            autoRotate.toggle()
                        }) {
                            VStack {
                                Image(systemName: autoRotate ? "pause.fill" : "play.fill")
                                    .font(.title2)
                                Text(autoRotate ? "Pause" : "Rotate")
                                    .font(.caption)
                            }
                            .padding(12)
                            .background(.ultraThinMaterial)
                            .cornerRadius(12)
                        }
                    }
                    .padding()
                }
                .padding(.bottom)
            }
        }
        .confirmationDialog("Export Model", isPresented: $showingExportOptions) {
            ForEach(ExportFormat.allCases) { format in
                Button(format.rawValue) {
                    exportFormat = format
                    exportModel(format: format)
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Choose a format to export")
        }
    }
    
    // In ModelDetailView.swift
    private func exportModel(format: ExportFormat) {
        // For now, just share the original USDZ file regardless of selected format
        let activityVC = UIActivityViewController(
            activityItems: [model.url],
            applicationActivities: nil
        )
        
        // Present the share sheet using UIApplication
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }
    
    private func shareModelFile(_ url: URL) {
        let shareView = ShareSheet(items: [url])
        let hostingController = UIHostingController(rootView: shareView)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(hostingController, animated: true)
        }
    }
}

// A SwiftUI wrapper for SceneKit view
struct SceneKitModelView: UIViewRepresentable {
    let url: URL
    var scale: Float
    var autoRotate: Bool
    
    func makeUIView(context: Context) -> SCNView {
        let sceneView = SCNView()
        sceneView.backgroundColor = .clear
        sceneView.allowsCameraControl = true
        sceneView.autoenablesDefaultLighting = true
        sceneView.scene = createScene()
        return sceneView
    }
    
    func updateUIView(_ sceneView: SCNView, context: Context) {
        if let rootNode = sceneView.scene?.rootNode.childNodes.first {
            // Update scale
            rootNode.scale = SCNVector3(scale, scale, scale)
            
            // Handle rotation
            rootNode.removeAllAnimations()
            if autoRotate {
                let rotateAction = SCNAction.rotate(by: .pi * 2, around: SCNVector3(0, 1, 0), duration: 10)
                let repeatAction = SCNAction.repeatForever(rotateAction)
                rootNode.runAction(repeatAction)
            }
        }
    }
    
    private func createScene() -> SCNScene? {
        do {
            let scene = try SCNScene(url: url, options: nil)
            return scene
        } catch {
            print("Failed to load model: \(error)")
            return nil
        }
    }
}

// SwiftUI ShareSheet - A wrapper around UIActivityViewController
struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// Then add this struct:
struct ARQuickLookView: UIViewControllerRepresentable {
    let modelURL: URL
    
    func makeUIViewController(context: Context) -> QLPreviewController {
        let controller = QLPreviewController()
        controller.dataSource = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: QLPreviewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, QLPreviewControllerDataSource {
        let parent: ARQuickLookView
        
        init(_ parent: ARQuickLookView) {
            self.parent = parent
        }
        
        func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
            return 1
        }
        
        func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
            return parent.modelURL as QLPreviewItem
        }
    }
}
