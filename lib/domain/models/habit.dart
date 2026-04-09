enum HabitDifficulty { easy, medium, hard }

class Habit {
  final String id;
  final String name;
  final bool isCompleted;
  final int streak;
  final HabitDifficulty difficulty;
  final DateTime lastCompleted;

  /// Duration in minutes for the countdown timer
  final int timerDuration;

  /// Precise date and time the habit was created or scheduled for
  final DateTime createdAt;

  /// Optional specific time to trigger a local push notification
  final DateTime? reminderTime;

  Habit({
    required this.id,
    required this.name,
    this.isCompleted = false,
    this.streak = 0,
    required this.difficulty,
    required this.lastCompleted,
    this.timerDuration = 10,
    DateTime? createdAt,
    this.reminderTime, // Integrated into constructor
  }) : createdAt = createdAt ?? DateTime.now();

  /// Calculates XP reward based on difficulty for the gamification engine
  int get xpValue {
    switch (difficulty) {
      case HabitDifficulty.easy:
        return 10;
      case HabitDifficulty.medium:
        return 20;
      case HabitDifficulty.hard:
        return 40;
    }
  }

  // --- Persistence Logic (Map/JSON) ---

  /// Converts the Habit object into a Map for local storage (SharedPreferences)
  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'isCompleted': isCompleted,
    'streak': streak,
    'difficulty': difficulty.index, // Save as Int for efficiency
    'lastCompleted': lastCompleted.toIso8601String(),
    'timerDuration': timerDuration,
    'createdAt': createdAt.toIso8601String(),
    // Safely encode the optional reminder time
    'reminderTime': reminderTime?.toIso8601String(),
  };

  /// Reconstructs the Habit object from a Map stored on disk
  factory Habit.fromMap(Map<String, dynamic> map) => Habit(
    id: map['id'] ?? '',
    name: map['name'] ?? 'Unnamed Habit',
    isCompleted: map['isCompleted'] ?? false,
    streak: map['streak'] ?? 0,
    difficulty: HabitDifficulty.values[map['difficulty'] ?? 0],
    lastCompleted: DateTime.parse(
      map['lastCompleted'] ?? DateTime.now().toIso8601String(),
    ),
    timerDuration: map['timerDuration'] ?? 10,
    createdAt: DateTime.parse(
      map['createdAt'] ?? DateTime.now().toIso8601String(),
    ),
    // Safely decode the optional reminder time
    reminderTime: map['reminderTime'] != null
        ? DateTime.parse(map['reminderTime'])
        : null,
  );

  // --- State Management Helpers ---

  /// Returns a new instance of Habit with updated fields, maintaining immutability
  Habit copyWith({
    String? name,
    bool? isCompleted,
    int? streak,
    HabitDifficulty? difficulty,
    DateTime? lastCompleted,
    int? timerDuration,
    DateTime? createdAt,
    DateTime? reminderTime,
  }) => Habit(
    id: id, // ID is never changed
    name: name ?? this.name,
    isCompleted: isCompleted ?? this.isCompleted,
    streak: streak ?? this.streak,
    difficulty: difficulty ?? this.difficulty,
    lastCompleted: lastCompleted ?? this.lastCompleted,
    timerDuration: timerDuration ?? this.timerDuration,
    createdAt: createdAt ?? this.createdAt,
    reminderTime: reminderTime ?? this.reminderTime,
  );
}
