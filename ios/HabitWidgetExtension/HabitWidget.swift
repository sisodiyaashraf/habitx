import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), mascotImagePath: nil, habits: [])
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), mascotImagePath: nil, habits: [])
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        let currentDate = Date()

        // Access App Group shared UserDefaults
        let sharedPrefs = UserDefaults(suiteName: "group.habitx_glass_data")
        let mascotPath = sharedPrefs?.string(forKey: "mascot_image")
        
        var habitsList: [HabitModel] = []
        if let habitsJsonStr = sharedPrefs?.string(forKey: "habits_json"),
           let habitsJsonData = habitsJsonStr.data(using: .utf8) {
            do {
                habitsList = try JSONDecoder().decode([HabitModel].self, from: habitsJsonData)
            } catch {
                print("HabitX iOS Widget decoding error: \(error)")
            }
        }

        let entry = SimpleEntry(date: currentDate, mascotImagePath: mascotPath, habits: habitsList)
        entries.append(entry)

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let mascotImagePath: String?
    let habits: [HabitModel]
}

struct HabitWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            // Background Layer: Mascot image (Covers fully)
            if let path = entry.mascotImagePath,
               let uiImage = UIImage(contentsOfFile: path) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else {
                // Fallback background color
                Color(red: 0.1, green: 0.1, blue: 0.1)
            }

            // Dark semi-transparent overlay to ensure text readability
            Color.black.opacity(0.7)

            // Content Layer
            VStack(alignment: .leading, spacing: 6) {
                Text("MISSIONS")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(Color(red: 0.67, green: 0.36, blue: 0.93)) // Brand Purple

                if entry.habits.isEmpty {
                    Text("No active missions today.")
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.6))
                        .padding(.top, 4)
                } else {
                    ForEach(entry.habits.prefix(3)) { habit in
                        HStack(spacing: 8) {
                            // Checkbox Button
                            if #available(iOS 17.0, *) {
                                Button(intent: CompleteHabitIntent(id: habit.id)) {
                                    Image(systemName: habit.isCompleted ? "checkmark.circle.fill" : "circle")
                                        .font(.system(size: 18))
                                        .foregroundColor(habit.isCompleted ? .green : .white.opacity(0.5))
                                }
                                .buttonStyle(.plain)
                            } else {
                                // Fallback without interactivity
                                Image(systemName: habit.isCompleted ? "checkmark.circle.fill" : "circle")
                                    .font(.system(size: 18))
                                    .foregroundColor(habit.isCompleted ? .green : .white.opacity(0.5))
                            }

                            Text(habit.name)
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(.white)
                                .lineLimit(1)
                            
                            Spacer()
                            
                            Text("\(habit.streak) 🔥")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.orange)
                        }
                    }
                }
                Spacer(minLength: 0)
            }
            .padding(12)
        }
    }
}

struct HabitWidget: Widget {
    let kind: String = "HabitWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            HabitWidgetEntryView(entry: entry)
                .containerBackground(Color(red: 0.1, green: 0.1, blue: 0.1), for: .widget)
        }
        .configurationDisplayName("HabitX Interactive Widget")
        .description("Manage your daily habit objectives directly from the home screen.")
        .supportedFamilies([.systemMedium])
    }
}
