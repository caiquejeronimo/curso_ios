import SwiftUI

struct ContentView: View {

    @State private var viewModel = TaskViewModel()

    var body: some View {

        NavigationStack {
            VStack {
                HStack {
                    TextField(
                        "Nova tarefa",
                        text: $viewModel.newTaskTitle
                    )
                    .textFieldStyle(.roundedBorder)
                    Button {
                        viewModel.addTask()
                    } label: {
                        Image(systemName: "plus")
                            .font(.headline)
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()

                if viewModel.tasks.isEmpty {

                    ContentUnavailableView(
                        "Nenhuma tarefa",
                        systemImage: "checklist",
                        description: Text(
                            "Adicione uma tarefa para começar."
                        )
                    )

                } else {
                    List {
                        ForEach(viewModel.tasks) { task in
                            TaskRowView(
                                task: task
                            ) {
                                viewModel.toggleTask(task)
                            }
                        }
                        .onDelete(
                            perform: viewModel.deleteTask
                        )
                    }
                }
            }
            .navigationTitle("Minhas Tarefas")
        }
    }
}

#Preview {
    ContentView()
}
