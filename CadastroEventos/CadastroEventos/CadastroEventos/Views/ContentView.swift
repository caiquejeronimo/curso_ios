import SwiftUI
import SwiftData

struct ContentView: View {

    @Environment(\.modelContext)
    private var modelContext

    @State private var viewModel: EventViewModel?

    var body: some View {
        Group {
            if let viewModel {
                EventListView(viewModel: viewModel)
            } else {
                ProgressView("Carregando eventos...")
                    .task {
                        createViewModel()
                    }
            }
        }
    }

    private func createViewModel() {
        guard viewModel == nil else {
            return
        }

        viewModel = EventViewModel(
            modelContext: modelContext
        )
    }
}

#Preview {
    ContentView()
        .modelContainer(
            for: Event.self,
            inMemory: true
        )
}
