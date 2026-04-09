import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationManager {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );
    await _notifications.initialize(settings: settings);
    _scheduleDailyMotivations();
  }

  static void _scheduleDailyMotivations() {
    // Times: 9:00, 13:00, 18:00, 21:00
    final hours = [9, 13, 18, 21];
    for (var hour in hours) {
      _scheduleDaily(hour, "Time to level up! Check your habits.");
    }
  }

  static void _scheduleDaily(int hour, String body) {
    // Standard logic to schedule daily at specific 'hour' using tz.TZDateTime
  }
}
