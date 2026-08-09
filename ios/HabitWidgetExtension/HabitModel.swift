import Foundation

struct HabitModel: Codable, Identifiable {
    var id: String
    var name: String
    var isCompleted: Bool
    var streak: Int
}
