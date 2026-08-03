import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:habitx/domain/models/shelby_persona.dart';
import 'package:habitx/core/constants/habit_templates.dart';
import 'package:habitx/core/constants/notification_messages.dart';
import 'package:habitx/providers/habit_provider.dart';
import 'package:habitx/data/services/notifications/habit_x_notification_service.dart';

class MockHabitXNotificationService extends HabitXNotificationService {
  MockHabitXNotificationService._() : super.internal();
  factory MockHabitXNotificationService() => MockHabitXNotificationService._();

  @override
  Future<void> init() async {}

  @override
  Future<void> scheduleHabitReminder(
    String habitId,
    String name,
    DateTime targetTime, {
    DateTime? createdAt,
  }) async {}

  @override
  Future<void> cancelReminder(String habitId) async {}

  @override
  Future<void> showInstantNotification({required String title, required String body, int id = 0}) async {}

  @override
  Future<void> scheduleDailyBriefings() async {}

  @override
  Future<void> cancelDailyBriefings() async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel homeWidgetChannel = MethodChannel('home_widget');
  late MockHabitXNotificationService mockNotificationService;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(homeWidgetChannel, (MethodCall methodCall) async {
      return null;
    });

    mockNotificationService = MockHabitXNotificationService();
    HabitXNotificationService.setMockInstance(mockNotificationService);
  });

  group('Feature 1 - AI Moods Tests', () {
    test('Persona resolution mappings from userPersona', () async {
      final provider = HabitProvider();
      await provider.init();

      provider.updatePersona('Flirty');
      expect(provider.activePersona, ShelbyPersona.flirty);

      provider.updatePersona('GenZ');
      expect(provider.activePersona, ShelbyPersona.genz);

      provider.updatePersona('Roast');
      expect(provider.activePersona, ShelbyPersona.roast);

      provider.updatePersona('SHELBY AI');
      expect(provider.activePersona, ShelbyPersona.overlord);

      provider.updatePersona('Professional');
      expect(provider.activePersona, ShelbyPersona.motivational);
    });

    test('getInAppBriefing returns non-empty persona briefing strings', () {
      final text = NotificationMessages.getInAppBriefing(
        persona: ShelbyPersona.roast,
        context: 'nudge',
        username: 'Tester',
      );
      expect(text, contains('embarrassed'));
    });
  });

  group('Feature 2 - Accessibility Pass Tests', () {
    test('toggleReduceMotion persists preference value', () async {
      final provider = HabitProvider();
      await provider.init();

      expect(provider.isReduceMotionActive, isFalse);

      provider.toggleReduceMotion(true);
      expect(provider.isReduceMotionActive, isTrue);

      // Re-init provider to assert persistence
      final provider2 = HabitProvider();
      await provider2.init();
      expect(provider2.isReduceMotionActive, isTrue);
    });
  });

  group('Feature 3 - Habit Templates Tests', () {
    test('Template presets definitions', () {
      expect(HabitTemplates.presets.length, greaterThanOrEqualTo(10));
      final water = HabitTemplates.presets.firstWhere((t) => t.id == 'template_water');
      expect(water.name, equals('Drink Water'));
      expect(water.suggestedFrequency, equals('daily'));
    });
  });
}
