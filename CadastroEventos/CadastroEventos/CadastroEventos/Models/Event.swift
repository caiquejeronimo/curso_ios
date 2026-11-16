import Foundation
import SwiftData

@Model
class Event {
    var title: String
    var desc: String
    var date: Date
    var place: String
    
    init(title: String, desc: String, date: Date = .now, place: String) {
        self.title = title
        self.desc = desc
        self.date = date
        self.place = place
    }
}
