import SwiftUI

@main
struct SmileSprintApp: App {
    @StateObject private var model = EmotionalModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(model)
        }
    }
}
