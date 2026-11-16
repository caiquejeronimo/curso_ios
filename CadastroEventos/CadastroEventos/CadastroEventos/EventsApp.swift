import SwiftUI
import SwiftData

@main
struct EventsApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Event.self)
    }
}
