import SwiftUI

struct EventListView: View {

    @Bindable var viewModel: EventViewModel

    @State private var showingNewEvent = false

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.filteredEvents.isEmpty {
                    emptyState
                } else {
                    eventsList
                }
            }
            .navigationTitle("Meus Eventos")
            .searchable(
                text: $viewModel.searchText,
                prompt: "Buscar por título ou local"
            )
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.cleanFields()
                        showingNewEvent = true
                    } label: {
                        Label(
                            "Novo evento",
                            systemImage: "plus"
                        )
                    }
                }
            }
            .sheet(isPresented: $showingNewEvent) {
                SaveEventView(viewModel: viewModel)
            }
            .onAppear {
                viewModel.listEvents()
            }
        }
    }

    private var eventsList: some View {
        List {
            ForEach(viewModel.filteredEvents) { event in
                EventRowView(event: event)
            }
            .onDelete { offsets in
                viewModel.deleteEvent(at: offsets)
            }
        }
        .listStyle(.plain)
    }


    private var emptyState: some View {
        ContentUnavailableView(
            emptyTitle,
            systemImage: emptyIcon,
            description: Text(emptyDescription)
        )
    }

    private var emptyTitle: String {
        viewModel.searchText.isEmpty
            ? "Nenhum evento"
            : "Nenhum resultado"
    }

    private var emptyIcon: String {
        viewModel.searchText.isEmpty
            ? "calendar.badge.plus"
            : "magnifyingglass"
    }

    private var emptyDescription: String {
        viewModel.searchText.isEmpty
            ? "Cadastre seu primeiro evento."
            : "Nenhum evento corresponde à pesquisa."
    }
}
