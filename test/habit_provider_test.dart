import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitx/providers/habit_provider.dart';
import 'package:habitx/domain/models/habit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:habitx/data/services/notifications/habit_x_notification_service.dart';

class MockHabitXNotificationService extends HabitXNotificationService {
  MockHabitXNotificationService._() : super.internal();
  factory MockHabitXNotificationService() => MockHabitXNotificationService._();

  @override
  Future<void> init() async {}

  @override
  Future<void> scheduleHabitReminder(String habitId, String name, DateTime targetTime) async {}

  @override
  Future<void> cancelReminder(String habitId) async {}

  @override
  Future<void> showInstantNotification({required String title, required String body, int id = 0}) async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel homeWidgetChannel = MethodChannel('home_widget');

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    
    // Mock HomeWidget calls to avoid MissingPluginException
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(homeWidgetChannel, (MethodCall methodCall) async {
      return null;
    });

    // Set mock notification service
    HabitXNotificationService.setMockInstance(MockHabitXNotificationService());
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
}
