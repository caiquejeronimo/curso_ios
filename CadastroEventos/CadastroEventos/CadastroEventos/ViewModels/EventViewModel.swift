import Foundation
import Observation
import SwiftData

@MainActor
@Observable
class EventViewModel {

    private let modelContext: ModelContext

    private(set) var events: [Event] = []

    var editingEvent: Event?

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

        do {
            events = try modelContext.fetch(descriptor)
        } catch {
            events = []
            print("Erro ao listar eventos: \(error)")
        }
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

        let newEvent = Event(
            title: cleanTitle,
            desc: cleanDescription,
            date: date,
            place: cleanPlace
        )

        modelContext.insert(newEvent)

        do {
            try modelContext.save()
            
            events.append(newEvent)
            
            cleanFields()
            
            return true
        } catch {
            print("Erro ao salvar evento: \(error)")
            listEvents()
            
            return false
        }

    }

    func deleteEvent(_ event: Event) {
        let eventID = event.id

        events.removeAll { $0.id == eventID }

        modelContext.delete(event)

        do {
            try modelContext.save()
        } catch {
            print("Erro ao excluir evento: \(error)")

            listEvents()
        }
    }

    func startEditing(_ event: Event) {
        editingEvent = event

        title = event.title
        desc = event.desc
        date = event.date
        place = event.place
    }

    @discardableResult
    func updateEvent() -> Bool {
        guard let event = editingEvent else {
            return false
        }

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

        event.title = cleanTitle
        event.desc = cleanDescription
        event.date = date
        event.place = cleanPlace

        do {
            try modelContext.save()

            events.sort {
                $0.date < $1.date
            }

            cleanFields()

            return true
        } catch {
            print("Erro ao atualizar evento: \(error)")
            listEvents()

            return false
        }
    }

    @discardableResult
    func save() -> Bool {
        if editingEvent != nil {
            return updateEvent()
        }
        
        return saveEvent()
    }
    // limpa form
    func cleanFields() {
        title = ""
        desc = ""
        date = .now
        place = ""
    }
}
