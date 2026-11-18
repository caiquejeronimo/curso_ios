import Foundation
import SwiftData

@Model
class Event {
    var id: UUID
    
    var title: String
    var desc: String
    var date: Date
    var place: String
    
    init(id: UUID = UUID(),title: String, desc: String, date: Date = .now, place: String) {
        self.id = id
        self.title = title
        self.desc = desc
        self.date = date
        self.place = place
    }
}
