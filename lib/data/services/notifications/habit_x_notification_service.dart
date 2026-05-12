import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import '../storage_service.dart';
import '../../../core/constants/notification_messages.dart';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  debugPrint(
    'HabitX: Background Notification Tapped [ID: ${notificationResponse.id}]',
  );
}

class HabitXNotificationService {
  static HabitXNotificationService? _customInstance;
  static final HabitXNotificationService _instance =
      HabitXNotificationService.internal();
  factory HabitXNotificationService() => _customInstance ?? _instance;
  HabitXNotificationService.internal();

  @visibleForTesting
  static void setMockInstance(HabitXNotificationService mock) {
    _customInstance = mock;
  }

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  // Channel constants
  static const String _habitChannelId = "habit_x_reminders";
  static const String _habitChannelName = "Habit Reminders";
  static const String _briefingChannelId = "habit_x_briefings";
  static const String _briefingChannelName = "SHELBY AI Daily";

  Future<void> init() async {
    if (_isInitialized) return;

    try {
      // 1. Initialize Timezones with Robust Fallback
      tz_data.initializeTimeZones();
      try {
        final TimezoneInfo timezoneName =
            await FlutterTimezone.getLocalTimezone();
        tz.setLocalLocation(tz.getLocation(timezoneName as String));
        debugPrint("HabitX: Timezone Locked to $timezoneName");
      } catch (e) {
        debugPrint("HabitX: Timezone detection failed, using UTC fallback: $e");
        tz.setLocalLocation(tz.getLocation('UTC'));
      }

      // 2. Android Settings - Using standard 'ic_launcher'
      const AndroidInitializationSettings androidInit =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      // 3. Darwin (iOS/macOS) Settings
      const DarwinInitializationSettings darwinInit =
          DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
            notificationCategories: [],
          );

      // 4. Combined Settings
      const InitializationSettings initSettings = InitializationSettings(
        android: androidInit,
        iOS: darwinInit,
        macOS: darwinInit,
      );

      // 5. Initialize Plugin with detailed callbacks
      await _notifications.initialize(
        settings: initSettings,
        onDidReceiveNotificationResponse: (details) {
          debugPrint("HabitX: Foreground Interaction [ID: ${details.id}]");
        },
        onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
      );

      // 6. Create Android Channels explicitly
      if (Platform.isAndroid) {
        await _setupAndroidChannels();
      }

      _isInitialized = true;
      debugPrint("HabitX Notification Engine: ACTIVE");

      // 7. Schedule recurring background tasks
      await scheduleDailyBriefings();
    } catch (e) {
      debugPrint("HabitX Critical Engine Failure: $e");
    }
  }

  Future<void> _setupAndroidChannels() async {
    final androidPlugin = _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (androidPlugin != null) {
      // Habit Reminders: High Importance + Sound
      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          _habitChannelId,
          _habitChannelName,
          description: 'Tactical triggers for habit execution',
          importance: Importance.max,
          enableVibration: true,
          playSound: true,
          showBadge: true,
        ),
      );

      // Daily Briefings: High Importance
      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          _briefingChannelId,
          _briefingChannelName,
          description: 'Strategic daily coaching briefings',
          importance: Importance.high,
          playSound: true,
          showBadge: true,
        ),
      );
      debugPrint("HabitX: Android Channels Synchronized");
    }
  }

  /// 🚀 STRATEGIC PERMISSION HANDLER
  /// Handles the complex requirements for Android 13 (Notifications)
  /// and Android 14 (Exact Alarms).
  Future<bool> requestPermissions() async {
    debugPrint("HabitX: Initiating Permission Protocol...");

    if (Platform.isAndroid) {
      // 1. Notification Permission (Android 13+)
      PermissionStatus status = await Permission.notification.status;
      if (status.isDenied) {
        status = await Permission.notification.request();
      }

      // 2. Exact Alarm Permission (Android 14+)
      // This is critical for habit reminders that MUST fire at a specific time.
      if (await Permission.scheduleExactAlarm.isDenied) {
        debugPrint("HabitX: Exact Alarm Denied. Requesting...");
        await Permission.scheduleExactAlarm.request();
      }

      final bool isGranted = status.isGranted;
      debugPrint(
        "HabitX: Permission Status -> ${isGranted ? 'AUTHORIZED' : 'DENIED'}",
      );
      return isGranted;
    } else if (Platform.isIOS) {
      final iosPlugin = _notifications
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >();
      return await iosPlugin?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          ) ??
          false;
    }
    return true;
  }

  /// Schedules a recurring daily reminder for a habit
  Future<void> scheduleHabitReminder(
    String habitId,
    String name,
    DateTime targetTime,
  ) async {
    if (!_isInitialized) await init();

    final int baseId = (habitId.hashCode.abs() % 100000);
    final String persona =
        await StorageService().getUserPersona() ?? "Professional";

    final scheduledDate = _nextInstanceOfTime(
      targetTime.hour,
      targetTime.minute,
    );

    try {
      await _notifications.zonedSchedule(
        id: baseId,
        title: "Protocol Reminder: $name",
        body: NotificationMessages.getRandomPrompt(persona),
        scheduledDate: scheduledDate,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            _habitChannelId,
            _habitChannelName,
            importance: Importance.max,
            priority: Priority.max,
            icon: '@mipmap/ic_launcher',
            fullScreenIntent: true,
            category: AndroidNotificationCategory.reminder,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
            interruptionLevel: InterruptionLevel.timeSensitive,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );

      debugPrint(
        "HabitX: Scheduled Reminder for '$name' at ${targetTime.hour}:${targetTime.minute}",
      );
    } catch (e) {
      debugPrint("HabitX: Failed to schedule reminder for '$name': $e");
    }
  }

  /// Schedules daily briefings at set intervals
  Future<void> scheduleDailyBriefings() async {
    final String persona =
        await StorageService().getUserPersona() ?? "Professional";

    final briefings = [
      {'id': 7001, 'hour': 8, 'min': 30, 'title': 'Morning Briefing'},
      {'id': 7002, 'hour': 13, 'min': 0, 'title': 'Mid-Day Audit'},
      {'id': 7003, 'hour': 18, 'min': 0, 'title': 'Evening Push'},
      {'id': 7004, 'hour': 21, 'min': 30, 'title': 'Nightly Reflection'},
    ];

    for (var b in briefings) {
      final scheduledDate = _nextInstanceOfTime(
        b['hour'] as int,
        b['min'] as int,
      );

      await _notifications.zonedSchedule(
        id: b['id'] as int,
        title: "SHELBY AI: ${b['title']}",
        body: NotificationMessages.getRandomPrompt(persona),
        scheduledDate: scheduledDate,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            _briefingChannelId,
            _briefingChannelName,
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
          macOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

  /// Shows an instant notification
  Future<void> showInstantNotification({
    required String title,
    required String body,
    int id = 0,
  }) async {
    if (!_isInitialized) await init();

    await _notifications.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          _briefingChannelId,
          _briefingChannelName,
          importance: Importance.max,
          priority: Priority.max,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
        macOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
  }

  Future<void> cancelReminder(String habitId) async {
    final int baseId = (habitId.hashCode.abs() % 100000);
    await _notifications.cancel(id: baseId);
  }

  Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}
