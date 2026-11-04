import SwiftUI
import SwiftData

@main
struct AlumnosApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(ModelContainerProvider.shared.container)
        }
    }
}
