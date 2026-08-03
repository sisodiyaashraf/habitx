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

  /// Historical list of dates when this habit was completed
  final List<DateTime> completedDates;

  /// Streak freeze tokens available for this habit (replenishes to 1 weekly)
  final int streakFreezesAvailable;

  /// Last date when streak freezes were replenished
  final DateTime lastFreezeResetDate;

  /// Historical list of dates when this habit's streak was frozen
  final List<DateTime> frozenDates;

  /// ID of the parent habit that triggers this habit in a habit stack chain
  final String? triggerHabitId;

  Habit({
    required this.id,
    required this.name,
    this.isCompleted = false,
    this.streak = 0,
    required this.difficulty,
    required this.lastCompleted,
    this.timerDuration = 10,
    DateTime? createdAt,
    this.reminderTime,
    List<DateTime>? completedDates,
    this.streakFreezesAvailable = 1,
    DateTime? lastFreezeResetDate,
    List<DateTime>? frozenDates,
    this.triggerHabitId,
  })  : createdAt = createdAt ?? DateTime.now(),
        completedDates = completedDates ?? [],
        lastFreezeResetDate = lastFreezeResetDate ?? DateTime.now().subtract(const Duration(days: 8)),
        frozenDates = frozenDates ?? [];

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
    'completedDates': completedDates.map((d) => d.toIso8601String()).toList(),
    'streakFreezesAvailable': streakFreezesAvailable,
    'lastFreezeResetDate': lastFreezeResetDate.toIso8601String(),
    'frozenDates': frozenDates.map((d) => d.toIso8601String()).toList(),
    'triggerHabitId': triggerHabitId,
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
    completedDates: map['completedDates'] != null
        ? (map['completedDates'] as List)
            .map((d) => DateTime.parse(d.toString()))
            .toList()
        : [],
    streakFreezesAvailable: map['streakFreezesAvailable'] ?? 1,
    lastFreezeResetDate: map['lastFreezeResetDate'] != null
        ? DateTime.parse(map['lastFreezeResetDate'])
        : DateTime.now().subtract(const Duration(days: 8)),
    frozenDates: map['frozenDates'] != null
        ? (map['frozenDates'] as List)
            .map((d) => DateTime.parse(d.toString()))
            .toList()
        : [],
    triggerHabitId: map['triggerHabitId'],
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
    List<DateTime>? completedDates,
    int? streakFreezesAvailable,
    DateTime? lastFreezeResetDate,
    List<DateTime>? frozenDates,
    String? Function()? triggerHabitId,
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
    completedDates: completedDates ?? this.completedDates,
    streakFreezesAvailable: streakFreezesAvailable ?? this.streakFreezesAvailable,
    lastFreezeResetDate: lastFreezeResetDate ?? this.lastFreezeResetDate,
    frozenDates: frozenDates ?? this.frozenDates,
    triggerHabitId: triggerHabitId != null ? triggerHabitId() : this.triggerHabitId,
  );
}

extension DateTimeExtension on DateTime {
  bool isSameDay(DateTime other) =>
      year == other.year && month == other.month && day == other.day;
}
