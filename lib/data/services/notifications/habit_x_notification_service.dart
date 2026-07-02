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
void notificationTapBackground(NotificationResponse details) {
  debugPrint('HabitX Neural Engine: Background Engagement [ID: ${details.id}]');
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

  // v9: New channel ID forces the OS to re-apply the high-priority "Alarm" status
  static const String _habitChannelId = "habit_x_neural_v9";
  static const String _briefingChannelId = "habit_x_briefings_v9";

  Future<void> init() async {
    if (_isInitialized) return;

    try {
      debugPrint("HabitX: Starting Neural Handshake...");

      tz_data.initializeTimeZones();
      final TimezoneInfo info = await FlutterTimezone.getLocalTimezone();
      String identifier = info.identifier; // Fixed: Accessed identifier string

      if (identifier == "Asia/Calcutta" || identifier.contains("Calcutta")) {
        identifier = "Asia/Kolkata";
      }

      try {
        tz.setLocalLocation(tz.getLocation(identifier));
      } catch (e) {
        debugPrint("HabitX Timezone lookup failed for '$identifier', falling back to UTC: $e");
        tz.setLocalLocation(tz.getLocation('UTC'));
      }
      debugPrint("HabitX: Timezone Locked to $identifier");

      // Points to android/app/src/main/res/drawable/ic_notif.png
      const androidInit = AndroidInitializationSettings('ic_notif');
      const darwinInit = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      // FIXED: Positional argument for InitializationSettings
      await _notifications.initialize(
        settings: const InitializationSettings(
          android: androidInit,
          iOS: darwinInit,
        ),
        onDidReceiveNotificationResponse: (NotificationResponse details) {
          debugPrint("HabitX: Foreground Interaction [ID: ${details.id}]");
        },
        onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
      );

      if (Platform.isAndroid) {
        await _setupAndroidChannels();
      }

      _isInitialized = true;
      debugPrint("HabitX Notification Engine: ACTIVE");
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
      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          _habitChannelId,
          'Critical Habit Missions',
          importance: Importance.max, // Wakes the device
          enableVibration: true,
          playSound: true,
          showBadge: true,
        ),
      );

      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          _briefingChannelId,
          'SHELBY AI Daily',
          importance: Importance.high,
          showBadge: true,
        ),
      );
    }
  }

  Future<bool> requestPermissions() async {
    if (Platform.isAndroid) {
      await Permission.notification.request();

      final androidPlugin = _notifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();

      // CRITICAL: Force prompt for Exact Alarm permission
      await androidPlugin?.requestExactAlarmsPermission();

      if (await Permission.scheduleExactAlarm.isDenied) {
        await Permission.scheduleExactAlarm.request();
      }

      // Request ignoring battery optimization to prevent background thread throttling
      if (await Permission.ignoreBatteryOptimizations.isDenied) {
        await Permission.ignoreBatteryOptimizations.request();
      }

      return (await Permission.notification.isGranted);
    }
    return true;
  }

  /// 🎯 THE FULL REMINDER PROTOCOL FOR SPECIFIC HABIT TASK
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
      // 2. The Main Execution with specific habit task details
      await _notifications.zonedSchedule(
        id: baseId,
        title: "Habit Reminder: $name 🚀",
        body: "Time for '$name'! ${NotificationMessages.getRandomPrompt(persona)}",
        scheduledDate: scheduledDate,
        notificationDetails: _missionDetails(),
        androidScheduleMode:
            AndroidScheduleMode.exactAllowWhileIdle, // Bypasses system 'Doze'
        matchDateTimeComponents: DateTimeComponents.time,
      );
      debugPrint("HabitX: Armed exact reminder for habit '$name' at $scheduledDate");
    } catch (e) {
      debugPrint("HabitX: Exact alarm scheduling failed for '$name', trying inexact fallback: $e");
      try {
        await _notifications.zonedSchedule(
          id: baseId,
          title: "Habit Reminder: $name 🚀",
          body: "Time for '$name'! ${NotificationMessages.getRandomPrompt(persona)}",
          scheduledDate: scheduledDate,
          notificationDetails: _missionDetails(),
          androidScheduleMode:
              AndroidScheduleMode.inexactAllowWhileIdle, // Fallback without permission
          matchDateTimeComponents: DateTimeComponents.time,
        );
        debugPrint("HabitX: Armed inexact fallback reminder for habit '$name' at $scheduledDate");
      } catch (innerErr) {
        debugPrint("HabitX Critical: Failed to schedule fallback reminder for '$name': $innerErr");
      }
    }
  }

  Future<void> scheduleDailyBriefings() async {
    final String persona =
        await StorageService().getUserPersona() ?? "Professional";
    final briefings = [
      {'id': 7001, 'h': 8, 'm': 30, 't': 'Morning Briefing'},
      {'id': 7002, 'h': 13, 'm': 0, 't': 'Mid-Day Audit'},
      {'id': 7003, 'h': 18, 'm': 0, 't': 'Evening Push'},
      {'id': 7004, 'h': 21, 'm': 30, 't': 'Nightly Reflection'},
    ];

    for (var b in briefings) {
      final scheduledDate = _nextInstanceOfTime(b['h'] as int, b['m'] as int);
      try {
        await _notifications.zonedSchedule(
          id: b['id'] as int,
          title: "SHELBY AI: ${b['t']}",
          body: NotificationMessages.getRandomPrompt(persona),
          scheduledDate: scheduledDate,
          notificationDetails: NotificationDetails(
            android: AndroidNotificationDetails(
              _briefingChannelId,
              'SHELBY AI Briefing',
              importance: Importance.high,
              priority: Priority.high,
              icon: 'ic_notif',
            ),
          ),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          matchDateTimeComponents: DateTimeComponents.time,
        );
        debugPrint("HabitX: Armed exact briefing '${b['t']}' at $scheduledDate");
      } catch (e) {
        debugPrint("HabitX: Exact briefing scheduling failed for '${b['t']}', trying inexact fallback: $e");
        try {
          await _notifications.zonedSchedule(
            id: b['id'] as int,
            title: "SHELBY AI: ${b['t']}",
            body: NotificationMessages.getRandomPrompt(persona),
            scheduledDate: scheduledDate,
            notificationDetails: NotificationDetails(
              android: AndroidNotificationDetails(
                _briefingChannelId,
                'SHELBY AI Briefing',
                importance: Importance.high,
                priority: Priority.high,
                icon: 'ic_notif',
              ),
            ),
            androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
            matchDateTimeComponents: DateTimeComponents.time,
          );
          debugPrint("HabitX: Armed inexact briefing '${b['t']}' at $scheduledDate");
        } catch (innerErr) {
          debugPrint("HabitX Critical: Failed to schedule fallback briefing for '${b['t']}': $innerErr");
        }
      }
    }
  }

  NotificationDetails _missionDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        _habitChannelId,
        'Critical Habit Missions',
        importance: Importance.max,
        priority: Priority.max,
        icon: 'ic_notif',
        fullScreenIntent: true, // Wakes lockscreen
        category:
            AndroidNotificationCategory.alarm, // High priority system status
        visibility: NotificationVisibility.public,
        playSound: true,
        enableVibration: true,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        interruptionLevel: InterruptionLevel.timeSensitive,
      ),
    );
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

    // If target time has already passed (even by a second), schedule for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

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
      notificationDetails: _missionDetails(),
    );
  }

  Future<void> cancelReminder(String habitId) async {
    final int baseId = (habitId.hashCode.abs() % 100000);
    await _notifications.cancel(id: baseId);
    await _notifications.cancel(id: baseId + 10);
  }

  Future<void> cancelDailyBriefings() async {
    final briefingIds = [7001, 7002, 7003, 7004];
    for (var id in briefingIds) {
      await _notifications.cancel(id: id);
    }
    debugPrint("HabitX: Daily Briefings cancelled.");
  }

  Future<void> cancelAll() async => await _notifications.cancelAll();
}
