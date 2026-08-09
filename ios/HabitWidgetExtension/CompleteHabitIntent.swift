import AppIntents
import Foundation
import WidgetKit

@available(iOS 17.0, macOS 14.0, watchOS 10.0, *)
struct CompleteHabitIntent: AppIntent {
    static var title: LocalizedStringResource = "Complete Habit"
    static var description = IntentDescription("Marks a specific habit complete for today directly from the widget.")

    @Parameter(title: "Habit ID")
    var id: String

    init() {
        self.id = ""
    }

    init(id: String) {
        self.id = id
    }

    func perform() async throws -> some IntentResult {
        // Access App Group shared UserDefaults
        guard let sharedPrefs = UserDefaults(suiteName: "group.habitx_glass_data") else {
            return .result()
        }

        // Load, parse, toggle, serialize, and save
        if let habitsJsonData = sharedPrefs.string(forKey: "habits_json")?.data(using: .utf8) {
            do {
                var habits = try JSONDecoder().decode([HabitModel].self, from: habitsJsonData)
                if let index = habits.firstIndex(where: { $0.id == id }) {
                    let isCompleted = habits[index].isCompleted
                    habits[index].isCompleted = !isCompleted
                    if !isCompleted {
                        habits[index].streak += 1
                    } else {
                        habits[index].streak = max(0, habits[index].streak - 1)
                    }

                    // Save updated array back
                    let updatedData = try JSONEncoder().encode(habits)
                    if let updatedJsonStr = String(data: updatedData, encoding: .utf8) {
                        sharedPrefs.set(updatedJsonStr, forKey: "habits_json")
                        
                        // Increment/decrement completed_count in shared preferences for UI badges
                        let completedCount = sharedPrefs.integer(forKey: "completedCount")
                        sharedPrefs.set(max(0, completedCount + (isCompleted ? -1 : 1)), forKey: "completedCount")
                    }
                }
            } catch {
                print("HabitX iOS AppIntent parsing failure: \(error)")
            }
        }

        // Reload timelines immediately
        WidgetCenter.shared.reloadTimelines(ofKind: "HabitWidget")
        return .result()
    }
}
