import Foundation

struct MoodEntry: Identifiable, Codable {
    var id = UUID()
    var mood: String
    var notes: String
    var date: Date
    var hobbies: [String] // Array to store selected hobbies
}




