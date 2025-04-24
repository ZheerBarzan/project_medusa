import SwiftUI

struct LibraryView: View {
    // Access the shared app data model
    @Environment(AppDataModel.self) var appModel
    
    // State for showing the detail view
    @State private var selectedModel: ModelObjectItem? = nil
    
    // State for showing various action sheets and alerts
    @State private var showingRenameAlert = false
    @State private var newModelName = ""
    @State private var showingExportMenu = false
    @State private var showingDeleteConfirmation = false
    @State private var modelToDelete: ModelObjectItem? = nil
    
    // Sample data - will be replaced with actual models from filesystem
    @State private var models: [ModelObjectItem] = []
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 20) {
                    if models.isEmpty {
                        emptyLibraryView
                    } else {
                        ForEach(models) { model in
                            ModelCardView(model: model)
                                .onTapGesture {
                                    selectedModel = model
                                }
                                .contextMenu {
                                    modelContextMenu(for: model)
                                }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("My 3D Models")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button(action: {
                            // Sort by date
                            models.sort { $0.creationDate > $1.creationDate }
                        }) {
                            Label("Sort by Date", systemImage: "calendar")
                        }
                        
                        Button(action: {
                            // Sort by name
                            models.sort { $0.name < $1.name }
                        }) {
                            Label("Sort by Name", systemImage: "textformat.abc")
                        }
                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
                    }
                }
            }
            .fullScreenCover(item: $selectedModel) { model in
                ModelDetailView(model: model, onDismiss: {
                    selectedModel = nil
                })
            }
            .alert("Rename Model", isPresented: $showingRenameAlert) {
                TextField("New name", text: $newModelName)
                
                Button("Cancel", role: .cancel) {
                    newModelName = ""
                    selectedModel = nil
                }
                
                Button("Rename") {
                    if let model = selectedModel, !newModelName.isEmpty {
                        print("New name set to: \(newModelName)")
                        renameModel(model)
                    } else {
                        print("Missing model or empty name")
                    }
                }
            } message: {
                Text("Enter a new name for this model")
            }
            .confirmationDialog(
                "Delete Model",
                isPresented: $showingDeleteConfirmation,
                presenting: modelToDelete
            ) { model in
                Button("Delete", role: .destructive) {
                    deleteModel(model)
                    modelToDelete = nil
                }
                Button("Cancel", role: .cancel) {
                    modelToDelete = nil
                }
            } message: { model in
                Text("Are you sure you want to delete \(model.name)? This cannot be undone.")
            }
            .onAppear {
                loadModels()
            }
        }
    }
    
    // Empty state view
    private var emptyLibraryView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "cube.transparent")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundColor(.gray)
            
            Text("No 3D Models Yet")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Tap on the Camera tab to scan your first 3D model")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Spacer()
        }
        .frame(height: UIScreen.main.bounds.height * 0.7)
    }
    
    // Context menu for models
    @ViewBuilder
    private func modelContextMenu(for model: ModelObjectItem) -> some View {
        Button {
            selectedModel = model
            newModelName = model.name
            showingRenameAlert = true
        } label: {
            Label("Rename", systemImage: "pencil")
        }
        
        Button {
            selectedModel = model
            showingExportMenu = true
        } label: {
            Label("Export", systemImage: "square.and.arrow.up")
        }
        
        Button(role: .destructive) {
            modelToDelete = model
            showingDeleteConfirmation = true
        } label: {
            Label("Delete", systemImage: "trash")
        }
    }
    
    // Function to load models from the filesystem
    private func loadModels() {
        Task {
            let loadedModels = await ModelManager.sharedModel.getAllModels()
            
            // Update UI on main thread
            await MainActor.run {
                models = loadedModels
            }
        }
    }
    
    // Function to rename a model
    private func renameModel(_ model: ModelObjectItem) {
        print("Attempting to rename to: \(newModelName)")
        
        if newModelName.isEmpty {
            print("ERROR: New name is empty")
            return
        }
        
        if let index = models.firstIndex(where: { $0.id == model.id }) {
            let captureFolder = model.url.deletingLastPathComponent().deletingLastPathComponent()
            
            Task {
                let success = await ModelManager.sharedModel.renameModel(at: captureFolder, to: newModelName)
                
                if success {
                    await MainActor.run {
                        models[index].name = newModelName
                    }
                    loadModels()
                }
            }
        }
    }
    
    // Function to delete a model
    private func deleteModel(_ model: ModelObjectItem) {
        if let index = models.firstIndex(where: { $0.id == model.id }) {
            let folderURL = model.url.deletingLastPathComponent().deletingLastPathComponent()
            
            Task {
                let success = await ModelManager.sharedModel.deleteModel(at: folderURL)
                
                if success {
                    await MainActor.run {
                        models.remove(at: index)
                    }
                }
            }
        }
    }
}
