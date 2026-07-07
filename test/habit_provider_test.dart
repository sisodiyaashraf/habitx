import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitx/providers/habit_provider.dart';
import 'package:habitx/domain/models/habit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:habitx/data/services/notifications/habit_x_notification_service.dart';

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
}
