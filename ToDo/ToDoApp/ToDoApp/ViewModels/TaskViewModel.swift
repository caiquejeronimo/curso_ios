import Foundation
import Observation
import SwiftUI

@Observable
class TaskViewModel {
    var tasks: [Task] = []
    
    var newTaskTitle: String = ""
    
    func addTask() {
        
        let cleanTitle = newTaskTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !cleanTitle.isEmpty else {
            return
        }
        
        let task = Task(title: cleanTitle)
        
        tasks.append(task)
        newTaskTitle = ""
    }
    
    func toggleTask(_ task: Task) {
        
        guard let index = tasks.firstIndex(
            where: {$0.id == task.id}) else {
            return
        }
        
        tasks[index].isCompleted.toggle()
    }
    
    func deleteTask(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
    }
}
