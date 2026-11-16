import Foundation
import Observation
import SwiftData

@MainActor
@Observable
class EventViewModel {

    private let modelContext: ModelContext

    private(set) var events: [Event] = []

    var title = ""
    var desc = ""
    var date = Date.now
    var place = ""

    var searchText = ""

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        listEvents()
    }

    // Retorna os eventos filtrados
    var filteredEvents: [Event] {
        let search = searchText.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !search.isEmpty else {
            return events
        }

        return events.filter { event in
            event.title.localizedCaseInsensitiveContains(search)
                || event.place.localizedCaseInsensitiveContains(search)
        }
    }

    var canSave: Bool {
        let cleanTitle = title.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        let cleanDescription = desc.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        let cleanPlace = place.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        return !cleanTitle.isEmpty && !cleanDescription.isEmpty
            && !cleanPlace.isEmpty
    }

    // Busca os eventos dentro do swiftdata e ordena por data
    func listEvents() {
        let descriptor = FetchDescriptor<Event>(
            sortBy: [
                SortDescriptor(\Event.date, order: .forward)
            ]
        )

        events = (try? modelContext.fetch(descriptor)) ?? []
    }

    func saveEvent() -> Bool {
        let cleanTitle = title.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        let cleanDescription = desc.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        let cleanPlace = place.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !cleanTitle.isEmpty,
            !cleanDescription.isEmpty,
            !cleanPlace.isEmpty
        else {
            return false
        }

        let event = Event(
            title: cleanTitle,
            desc: cleanDescription,
            date: date,
            place: cleanPlace
        )

        modelContext.insert(event)

        do {
            try modelContext.save()
            cleanFields()
            listEvents()
            return true
        } catch {
            print("Erro ao salvar evento: \(error)")
            return false
        }

    }

    func deleteEvent(at offSets: IndexSet) {
        let visibleEvents = filteredEvents

        for index in offSets.sorted(by: >) {
            guard visibleEvents.indices.contains(index) else {
                continue
            }

            modelContext.delete(visibleEvents[index])
        }

        do {
            try modelContext.save()
            listEvents()
        } catch {
            print("Erro ao excluir evento: \(error)")
        }

    }

    // limpa form
    func cleanFields() {
        title = ""
        desc = ""
        date = .now
        place = ""
    }
}
