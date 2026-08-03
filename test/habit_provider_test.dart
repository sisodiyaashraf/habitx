import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitx/providers/habit_provider.dart';
import 'package:habitx/domain/models/habit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:habitx/data/services/notifications/habit_x_notification_service.dart';
import 'package:habitx/core/constants/notification_messages.dart';
import 'package:habitx/presentation/widgets/tracking/achievement_tracker.dart';

class MockHabitXNotificationService extends HabitXNotificationService {
  MockHabitXNotificationService._() : super.internal();
  factory MockHabitXNotificationService() => MockHabitXNotificationService._();

  bool scheduleDailyBriefingsCalled = false;
  bool cancelDailyBriefingsCalled = false;
  bool scheduleReminderCalled = false;

  @override
  Future<void> init() async {}

  @override
  Future<void> scheduleHabitReminder(
    String habitId,
    String name,
    DateTime targetTime, {
    DateTime? createdAt,
  }) async {
    scheduleReminderCalled = true;
  }

  @override
  Future<void> cancelReminder(String habitId) async {}

  @override
  Future<void> showInstantNotification({required String title, required String body, int id = 0}) async {}

  @override
  Future<void> scheduleDailyBriefings() async {
    scheduleDailyBriefingsCalled = true;
  }

  @override
  Future<void> cancelDailyBriefings() async {
    cancelDailyBriefingsCalled = true;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel homeWidgetChannel = MethodChannel('home_widget');
  late MockHabitXNotificationService mockNotificationService;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    
    // Mock HomeWidget calls to avoid MissingPluginException
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(homeWidgetChannel, (MethodCall methodCall) async {
      return null;
    });

    // Set mock notification service
    mockNotificationService = MockHabitXNotificationService();
    HabitXNotificationService.setMockInstance(mockNotificationService);
  });

  test('HabitX Logic: Deleting a habit should reduce list length', () async {
    final provider = HabitProvider();

    final habit = Habit(
      id: '1',
      name: 'Test Mission',
      difficulty: HabitDifficulty.easy,
      timerDuration: 10,
      createdAt: DateTime.now(),
      lastCompleted: DateTime.now(),
      isCompleted: false,
      streak: 0,
    );

    provider.addHabit(habit);
    expect(provider.allHabits.length, 1);

    provider.deleteHabit('1');
    expect(provider.allHabits.length, 0);
  });

  test('HabitX Preferences: Toggling haptics should update provider and persist preference', () async {
    final provider = HabitProvider();
    
    // Default haptics should be true
    expect(provider.isHapticsEnabled, true);

    // Toggle off
    provider.toggleHaptics(false);
    expect(provider.isHapticsEnabled, false);

    // Yield execution to allow storage save to complete
    await Future.delayed(const Duration(milliseconds: 50));

    // Verify it updates preferences
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool('haptics_enabled'), false);
  });

  test('HabitX Preferences: Toggling daily motivation should reschedule/cancel briefings', () async {
    final provider = HabitProvider();
    
    // Toggle on (default might be true, set false first then true)
    await provider.toggleDailyMotivation(false);
    expect(provider.isDailyMotivationEnabled, false);
    expect(mockNotificationService.cancelDailyBriefingsCalled, true);

    mockNotificationService.scheduleDailyBriefingsCalled = false;
    await provider.toggleDailyMotivation(true);
    expect(provider.isDailyMotivationEnabled, true);
    expect(mockNotificationService.scheduleDailyBriefingsCalled, true);
  });

  test('HabitX Profile Setup: Initializing and setup user should save settings correctly', () async {
    final provider = HabitProvider();
    
    await provider.setupUser(name: 'Commander Shepard', age: 29, persona: 'Renegade');
    
    expect(provider.userName, 'Commander Shepard');
    expect(provider.userAge, 29);
    expect(provider.userPersona, 'Renegade');
    expect(provider.isNewUser, false);

    // Verify updating name updates display name
    await provider.updateName('Spectre Shepard');
    expect(provider.userName, 'Spectre Shepard');
  });

  test('HabitX Habit Setup: Adding a habit with reminder schedules reminder', () async {
    final provider = HabitProvider();
    
    final targetTime = DateTime.now().add(const Duration(hours: 2));
    final habit = Habit(
      id: '2',
      name: 'Cardio Training',
      difficulty: HabitDifficulty.hard,
      timerDuration: 30,
      createdAt: DateTime.now(),
      lastCompleted: DateTime.now(),
      reminderTime: targetTime,
      isCompleted: false,
      streak: 0,
    );

    provider.addHabit(habit);
    expect(provider.allHabits.length, 1);
    expect(mockNotificationService.scheduleReminderCalled, true);
  });

  test('HabitX Daily Motivations: getUniquePromptsForWeek must return unique and randomized prompts for morning and evening briefings in a day', () {
    final personas = ['genz', 'overlord', 'elite'];
    for (final persona in personas) {
      final prompts = NotificationMessages.getUniquePromptsForWeek(persona);
      
      expect(prompts.length, 14);

      for (int day = 1; day <= 7; day++) {
        final morningPrompt = prompts[day - 1];
        final eveningPrompt = prompts[day + 6];
        expect(morningPrompt, isNot(equals(eveningPrompt)));
        expect(morningPrompt.isNotEmpty, true);
        expect(eveningPrompt.isNotEmpty, true);
      }
    }
  });

  test('HabitX Achievements: getAchievementData computes 11 achievements correctly based on provider state', () {
    final provider = HabitProvider();

    var achievements = AchievementTracker.getAchievementData(provider);
    expect(achievements.length, 11);
    
    for (final a in achievements) {
      expect(a['unlocked'], false);
    }

    final habit1 = Habit(
      id: 'h1',
      name: 'Read Book',
      difficulty: HabitDifficulty.easy,
      timerDuration: 10,
      createdAt: DateTime.now(),
      lastCompleted: DateTime.now(),
      isCompleted: true,
      streak: 5,
      completedDates: [DateTime.now(), DateTime.now().subtract(const Duration(days: 1))],
    );
    provider.addHabit(habit1);

    achievements = AchievementTracker.getAchievementData(provider);
    
    final initiate = achievements.firstWhere((a) => a['id'] == 'initiate');
    expect(initiate['unlocked'], true);

    final momentum = achievements.firstWhere((a) => a['id'] == 'momentum');
    expect(momentum['unlocked'], true);

    final focus = achievements.firstWhere((a) => a['id'] == 'focus');
    expect(focus['unlocked'], false);
  });

  group('Streak Freeze Token Tests', () {
    test('Can only freeze if freezes available, today incomplete, and yesterday intact', () {
      final provider = HabitProvider();
      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(days: 1));

      final habit = Habit(
        id: 'f1',
        name: 'Gym Workout',
        difficulty: HabitDifficulty.medium,
        createdAt: now.subtract(const Duration(days: 2)),
        lastCompleted: yesterday,
        completedDates: [yesterday],
        streak: 1,
        streakFreezesAvailable: 1,
      );

      provider.addHabit(habit);

      // Initially eligible to freeze today
      expect(provider.canFreezeHabit(provider.allHabits.first), true);

      // 1. Cannot freeze if no freezes left
      final noFreezeHabit = habit.copyWith(streakFreezesAvailable: 0);
      expect(provider.canFreezeHabit(noFreezeHabit), false);

      // 2. Cannot freeze if today is already completed
      final completedTodayHabit = habit.copyWith(isCompleted: true, completedDates: [yesterday, now]);
      expect(provider.canFreezeHabit(completedTodayHabit), false);

      // 3. Cannot freeze if yesterday was NOT intact (missed)
      final brokenStreakHabit = habit.copyWith(
        completedDates: [],
        streak: 0,
      );
      expect(provider.canFreezeHabit(brokenStreakHabit), false);
    });

    test('Consuming freeze decrements token, marks day frozen, preserves streak count', () {
      final provider = HabitProvider();
      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(days: 1));

      final habit = Habit(
        id: 'f2',
        name: 'Learn Dart',
        difficulty: HabitDifficulty.easy,
        createdAt: now.subtract(const Duration(days: 2)),
        lastCompleted: yesterday,
        completedDates: [yesterday],
        streak: 1,
        streakFreezesAvailable: 1,
      );

      provider.addHabit(habit);
      expect(provider.canFreezeHabit(provider.allHabits.first), true);

      // Trigger freeze
      // Mocking context
      provider.useStreakFreeze(null as dynamic, 'f2');

      final updated = provider.allHabits.first;
      expect(updated.streakFreezesAvailable, 0);
      expect(updated.frozenDates.length, 1);
      expect(updated.frozenDates.first.isSameDay(now), true);
      // Streak count should remain the same (not incremented, but not reset)
      expect(updated.streak, 1);
    });

    test('Streak logic correctly bridges over a frozen day on subsequent completion', () {
      final provider = HabitProvider();
      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(days: 1));
      final twoDaysAgo = now.subtract(const Duration(days: 2));

      // Habit was completed 2 days ago, frozen yesterday
      final habit = Habit(
        id: 'f3',
        name: 'Meditation',
        difficulty: HabitDifficulty.easy,
        createdAt: now.subtract(const Duration(days: 3)),
        lastCompleted: twoDaysAgo,
        completedDates: [twoDaysAgo],
        frozenDates: [yesterday],
        streak: 1, // streak is 1 from the completion 2 days ago
        streakFreezesAvailable: 0,
      );

      provider.addHabit(habit);

      // Complete today
      provider.toggleHabitCompletion(null as dynamic, 'f3');

      final updated = provider.allHabits.first;
      // Streak should correctly increment to 2 because yesterday was frozen (intact)
      expect(updated.streak, 2);
    });

    test('Freezes replenish on Monday threshold crossing', () async {
      final provider = HabitProvider();
      final now = DateTime.now();

      // Find the last Monday
      final daysToSubtract = (now.weekday - DateTime.monday) % 7;
      final lastMonday = DateTime(now.year, now.month, now.day).subtract(Duration(days: daysToSubtract));

      // Reset date was before last Monday, and freezes are 0
      final habit = Habit(
        id: 'f4',
        name: 'Replenish Test',
        difficulty: HabitDifficulty.easy,
        createdAt: now.subtract(const Duration(days: 10)),
        lastCompleted: now,
        streakFreezesAvailable: 0,
        lastFreezeResetDate: lastMonday.subtract(const Duration(days: 2)), // 2 days before last Monday
      );

      provider.addHabit(habit);

      // Re-triggering init (which calls replenish freezes)
      await provider.init();

      // Yield execution to allow microtasks / storage callbacks to complete
      expect(provider.allHabits.first.streakFreezesAvailable, 1);
      expect(provider.allHabits.first.lastFreezeResetDate.isAfter(lastMonday.subtract(const Duration(days: 1))), true);
    });
  });

  group('Habit Stacking / Chaining Tests', () {
    test('Circular validation detects loop dependencies', () {
      final provider = HabitProvider();

      final habitA = Habit(
        id: 'A',
        name: 'Habit A',
        difficulty: HabitDifficulty.easy,
        lastCompleted: DateTime.now(),
      );
      final habitB = Habit(
        id: 'B',
        name: 'Habit B',
        difficulty: HabitDifficulty.easy,
        lastCompleted: DateTime.now(),
        triggerHabitId: 'A',
      );
      final habitC = Habit(
        id: 'C',
        name: 'Habit C',
        difficulty: HabitDifficulty.easy,
        lastCompleted: DateTime.now(),
      );

      provider.addHabit(habitA);
      provider.addHabit(habitB);
      provider.addHabit(habitC);

      // Setting B trigger to A is fine since B -> A -> null.
      expect(provider.isCircularChain('B', 'A'), false);

      // Setting C trigger to B is fine since C -> B -> A -> null.
      expect(provider.isCircularChain('C', 'B'), false);

      // Setting A trigger to B would create: A -> B -> A (Loop!) since B already triggers from A
      expect(provider.isCircularChain('A', 'B'), true);
      
      // Update A to trigger from B
      final updatedA = habitA.copyWith(triggerHabitId: () => 'B');
      provider.updateHabit(updatedA);

      // Now checking if B triggering from A is circular
      expect(provider.isCircularChain('B', 'A'), true);
    });

    test('Deleting trigger habit cascade-clears stacked triggerHabitId', () {
      final provider = HabitProvider();

      final parent = Habit(id: 'parent', name: 'Parent', difficulty: HabitDifficulty.easy, lastCompleted: DateTime.now());
      final child = Habit(id: 'child', name: 'Child', difficulty: HabitDifficulty.easy, lastCompleted: DateTime.now(), triggerHabitId: 'parent');

      provider.addHabit(parent);
      provider.addHabit(child);

      expect(provider.allHabits.length, 2);
      expect(provider.allHabits.firstWhere((h) => h.id == 'child').triggerHabitId, 'parent');

      // Delete parent
      provider.deleteHabit('parent');

      expect(provider.allHabits.length, 1);
      expect(provider.allHabits.first.triggerHabitId, isNull);
    });
  });
}
