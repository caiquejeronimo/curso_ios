import SwiftUI

struct SaveEventView: View {

    @Environment(\.dismiss)
    private var dismiss

    @Bindable var viewModel: EventViewModel

    var body: some View {
        NavigationStack {
            Form {
                eventInformationSection

                dateSection

                saveSection
            }
            .navigationTitle("Novo Evento")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        viewModel.cleanFields()
                        dismiss()
                    }
                }
            }
        }
    }

    private var eventInformationSection: some View {
        Section("Informações do evento") {
            TextField(
                "Título",
                text: $viewModel.title
            )

            TextField(
                "Descrição",
                text: $viewModel.desc,
                axis: .vertical
            )
            .lineLimit(3...6)

            TextField(
                "Local",
                text: $viewModel.place
            )
        }
    }

    private var dateSection: some View {
        Section("Data e horário") {
            DatePicker(
                "Data do evento",
                selection: $viewModel.date,
                displayedComponents: [
                    .date,
                    .hourAndMinute
                ]
            )
        }
    }

    private var saveSection: some View {
        Section {
            Button {
                let didSave = viewModel.saveEvent()

                if didSave {
                    dismiss()
                }
            } label: {
                Label(
                    "Cadastrar evento",
                    systemImage: "calendar.badge.plus"
                )
                .frame(maxWidth: .infinity)
            }
            .disabled(!viewModel.canSave)
        }
    }
}
