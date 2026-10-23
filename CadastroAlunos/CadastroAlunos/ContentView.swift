import SwiftUI

struct ContentView: View {
    
    // Variaveis @State
    @State private var name = ""
    @State private var grade1 = ""
    @State private var grade2 = ""
    
    @State private var students: [Student] = []
    
    @State private var errorMessage = ""
    
    private var iconColor = LinearGradient(colors: [.mint,.cyan, .indigo], startPoint: .topLeading, endPoint: .bottomTrailing)
    
    private var bgColor = LinearGradient(colors: [.indigo,.indigo,.cyan, .mint], startPoint: .topTrailing, endPoint: .bottomLeading)
    
    // Propriedades
    var totalStudents : Int {
        students.count
    }
    
    var approvedStudents: Int {
        students.filter {
            $0.average >= 7
        }.count
    }
    
    var failedStudents: Int {
        students.filter {
            $0.average < 7
        }.count
    }
    
    // Func
    
    private func addStudent() {

        guard !name.isEmpty else { return }

        guard let score1 = Double(grade1),
              let score2 = Double(grade2) else { return }

        guard (0...10).contains(score1),
              (0...10).contains(score2) else { return }

        let student = Student(
            name: name,
            grade1: score1,
            grade2: score2
        )

        students.append(student)

        name = ""
        grade1 = ""
        grade2 = ""
    }
    
    private func removeStudent(id: UUID) {
        students.removeAll {
            $0.id == id
        }
    }
    
    var body: some View {
        
        ScrollView {
            VStack(spacing: 20) {
                VStack(alignment: .center, spacing: 10) {
                    Image(systemName: "graduationcap.fill")
                        .font(.system(size: 50))
                        .foregroundStyle(iconColor)
                    Text("Minha Turma")
                        .font(.title)
                        .bold()
                    Text("Cadastre alunos e acompanhe os resultados")
                        .font(.headline)
                    
                }
                .frame(maxWidth: .infinity)
                // Card adicionar aluno
                VStack (alignment: .leading, spacing: 10){
                    Label("Cadastrar aluno", systemImage: "person.badge.plus")
                        .font(.system(size: 20))
                        .bold()
                        .padding(.bottom, 10)
                    Text("Nome do aluno")
                        .font(.title2)
                    CustomFieldView(value: $name, label: "Digite o nome completo").font(.title2)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Nota 1")
                            CustomFieldView(value: $grade1, label: "0 a 10")
                        }
                        VStack(alignment: .leading) {
                            Text("Nota 2")
                            CustomFieldView(value: $grade2, label: "0 a 10")
                        }
                    }
                    .font(.title2)
                    
                    Button(action: {
                        addStudent()
                    }) {
                        Label("Cadastrar Aluno", systemImage: "plus.circle.fill")
                            .bold()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.cyan.opacity(0.7))
                    .clipShape(Capsule())
                    .font(.title3)
                    .foregroundStyle(.black)
                    
                    
                }
                .padding()
                .glassEffect(.regular, in: .rect(cornerRadius: 20))
                
                // Resumo da turma
                VStack(alignment: .leading,spacing: 10) {
                    Text("Resumo da turma")
                        .font(.system(size: 20))
                        .bold()
                        .padding(.bottom, 20)
                    
                    HStack {
                        SummaryCard(
                            icon: "person.3.fill",
                            color: .blue,
                            value: totalStudents,
                            title: "Alunos"
                        )

                        Spacer()

                        SummaryCard(
                            icon: "checkmark.circle.fill",
                            color: .green,
                            value: approvedStudents,
                            title: "Aprovados"
                        )

                        Spacer()

                        SummaryCard(
                            icon: "x.circle.fill",
                            color: .red,
                            value: failedStudents,
                            title: "Reprovados"
                        )
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .glassEffect(.regular, in: .rect(cornerRadius: 20))
                
                // Alunos cadastrados
                
                VStack(spacing: 20) {
                    HStack() {
                        Text("Alunos Cadastrados")
                            .font(.system(size: 20))
                            .bold()
                        Spacer()
                        Text("\(totalStudents) registros")
                            .font(.system(size: 15))
                        
                        
                    }
                   
                    if totalStudents <= 0 {

                        Image(systemName: "person.crop.rectangle.stack")
                            .font(.system(size: 50))
                            .foregroundStyle(Color(uiColor: .systemGray))

                        Text("Nenhum aluno cadastrado")
                            .foregroundStyle(.secondary)

                    } else {

                        ForEach(students) { student in

                            VStack(alignment: .leading, spacing: 10) {

                                HStack {

                                    VStack(alignment: .leading, spacing: 5) {

                                        Text(student.name)
                                            .font(.headline)
                                        
                                        Text("Nota 1: \(student.grade1, specifier: "%.1f")")
                                        Text("Média: \(student.grade2, specifier: "%.1f")")
                                        Text("Média: \(student.average, specifier: "%.1f")")

                                        Label(
                                            student.status,
                                            systemImage: student.average >= 7
                                            ? "checkmark.circle.fill"
                                            : "xmark.circle.fill"
                                        )
                                        .foregroundStyle(
                                            student.average >= 7
                                            ? .green
                                            : .red
                                        )
                                    }

                                    Spacer()

                                    Button(action: {
                                        removeStudent(id: student.id)
                                    }) {
                                        Image(systemName: "trash.fill")
                                            .foregroundStyle(.red)
                                            .font(.title3)
                                    }
                                }
                            }
                            .padding()
                            .background(
                               Color(
                                student.average >= 7 ? .green.opacity(0.25) : .red.opacity(0.25)
                               )
                            )
                            //.background(.white.opacity(0.25))
                            .clipShape(
                                RoundedRectangle(cornerRadius: 15)
                            )
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .glassEffect(.regular, in: .rect(cornerRadius: 20))
                
            }
            .padding()
        }
        .background(bgColor)
        
       
    }

}

struct CustomFieldView: View {
    @Binding var value: String

    let label: String

    var body: some View {
        TextField(label, text: $value)
            .textFieldStyle(.plain)
            .padding(5)
            .background(RoundedRectangle(cornerRadius: 5)
                .fill(Color(uiColor: .systemGray6).opacity(0.5)))
    }
}

struct SummaryCard: View {

    let icon: String
    let color: Color
    let value: Int
    let title: String

    var body: some View {
        VStack(alignment: .center, spacing: 10) {

            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundStyle(color)

            Text("\(value)")
                .font(.title)
                .bold()

            Text(title)
        }
    }
}

#Preview {
    ContentView()
}

