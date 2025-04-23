import SwiftUI
import QuickLook
import ARKit

struct ModelDetailView: View {
    @Environment(AppDataModel.self) var appModel
    
    let model: ModelObjectItem
    let onDismiss: () -> Void

    var body: some View {
        ZStack {
            // Model view - using your existing implementation
            ModelView(modelFile: model.url, endCaptureCallback: {
                onDismiss()
            })
        }
        .navigationBarTitle("Model Details", displayMode: .inline)
    }
}
