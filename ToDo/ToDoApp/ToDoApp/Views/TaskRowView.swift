import SwiftUI

struct TaskRowView: View {

    let task: Task
    let onToggle: () -> Void

    var body: some View {

        HStack {
            Button {
                onToggle()
            } label: {
                Image(
                    systemName: task.isCompleted
                        ? "checkmark.circle.fill"
                        : "circle"
                )
                .foregroundStyle(
                    task.isCompleted
                        ? .green
                        : .gray
                )
                .font(.title2)
            }
            .buttonStyle(.plain)

            Text(task.title)
                .strikethrough(task.isCompleted)
                .foregroundStyle(
                    task.isCompleted
                        ? .secondary
                        : .primary
                )
            Spacer()
            Text(
                task.isCompleted
                    ? "Concluída"
                    : "Pendente"
            )
            .font(.caption)
            .foregroundStyle(
                task.isCompleted
                    ? .green
                    : .orange
            )
        }
    }
}
