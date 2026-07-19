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

  Future<void> scheduleHabitReminder(
    String habitId,
    String name,
    DateTime targetTime, {
    DateTime? createdAt,
  }) async {
    if (!_isInitialized) await init();

    final int baseId = (100000 + (habitId.hashCode.abs() % 100000));
    
    // Explicitly cancel the existing scheduled notification for this ID to ensure only one is scheduled
    await _notifications.cancel(id: baseId);

    final String userName = await StorageService().getUserName() ?? "User";
    final String title = "$userName, time for $name";
    final List<String> bodyPrompts = [
      "Stay consistent and complete your habit today! 🚀",
      "Every small step counts towards your goals. You got this! ⚡",
      "Make progress today and lock in your daily streak! 🏆",
      "Stay disciplined. Tap to complete your objective now! 🎯",
      "Consistency is the key to building lasting success! 🌟",
      "Don't break the chain! Log your habit completion today. 🔥",
      "Keep the momentum going. Time to execute your habit! ☄️",
      "Focus on your daily goal. Let's make today count! 💎",
    ];
    final int index = DateTime.now().microsecondsSinceEpoch % bodyPrompts.length;
    final String body = bodyPrompts[index];

    final scheduledDate = _nextInstanceOfTime(
      targetTime.hour,
      targetTime.minute,
    );

    try {
      // 1. Try with AlarmClock mode for absolute precision
      await _notifications.zonedSchedule(
        id: baseId,
        title: title,
        body: body,
        scheduledDate: scheduledDate,
        notificationDetails: _missionDetails(),
        androidScheduleMode: AndroidScheduleMode.alarmClock, // Bypasses all Doze restrictions, most precise
        matchDateTimeComponents: DateTimeComponents.time,
      );
      debugPrint("HabitX: Armed exact alarmClock reminder for habit '$name' at $scheduledDate");
    } catch (e) {
      debugPrint("HabitX: alarmClock scheduling failed for '$name', trying exactAllowWhileIdle fallback: $e");
      try {
        // 2. Fallback to exactAllowWhileIdle if alarmClock mode fails or is restricted
        await _notifications.zonedSchedule(
          id: baseId,
          title: title,
          body: body,
          scheduledDate: scheduledDate,
          notificationDetails: _missionDetails(),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          matchDateTimeComponents: DateTimeComponents.time,
        );
        debugPrint("HabitX: Armed exactAllowWhileIdle fallback reminder for habit '$name' at $scheduledDate");
      } catch (innerErr) {
        debugPrint("HabitX: exactAllowWhileIdle failed for '$name', trying inexact fallback: $innerErr");
        try {
          // 3. Fallback to inexactAllowWhileIdle if exact permissions are denied completely
          await _notifications.zonedSchedule(
            id: baseId,
            title: title,
            body: body,
            scheduledDate: scheduledDate,
            notificationDetails: _missionDetails(),
            androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
            matchDateTimeComponents: DateTimeComponents.time,
          );
          debugPrint("HabitX: Armed inexact fallback reminder for habit '$name' at $scheduledDate");
        } catch (finalErr) {
          debugPrint("HabitX Critical: Failed to schedule any reminder for '$name': $finalErr");
        }
      }
    }
  }

  Future<void> scheduleDailyBriefings() async {
    await cancelDailyBriefings();

    final String persona =
        await StorageService().getUserPersona() ?? "Professional";
    final String gender =
        await StorageService().getUserGender() ?? "Male";

    final messagesForWeek = NotificationMessages.getUniquePromptsForWeek(
      persona,
      gender: gender,
    );

    final briefings = [
      {'baseId': 7000, 'h': 9, 'm': 0, 't': 'Morning Motivation', 'msgIndexOffset': 0},
      {'baseId': 7010, 'h': 18, 'm': 0, 't': 'Evening Motivation', 'msgIndexOffset': 7},
    ];

    String titlePrefix;
    String channelName;
    switch (persona.toLowerCase()) {
      case 'genz':
        titlePrefix = "GenZ Coach";
        channelName = "GenZ Daily Briefing";
        break;
      case 'overlord':
      case 'habito':
      case 'shelby':
        titlePrefix = "SHELBY AI";
        channelName = "SHELBY AI Briefing";
        break;
      case 'elite':
      case 'professional':
      default:
        titlePrefix = "Elite Coach";
        channelName = "Elite Coach Briefing";
        break;
    }

    for (var b in briefings) {
      final int baseId = b['baseId'] as int;
      final int hour = b['h'] as int;
      final int minute = b['m'] as int;
      final String titleLabel = b['t'] as String;
      final int msgIndexOffset = b['msgIndexOffset'] as int;

      for (int day = 1; day <= 7; day++) {
        final int id = baseId + day;
        final scheduledDate = _nextInstanceOfWeekdayTime(day, hour, minute);
        final String bodyText = messagesForWeek[msgIndexOffset + (day - 1)];

        try {
          await _notifications.zonedSchedule(
            id: id,
            title: "$titlePrefix: $titleLabel",
            body: bodyText,
            scheduledDate: scheduledDate,
            notificationDetails: NotificationDetails(
              android: AndroidNotificationDetails(
                _briefingChannelId,
                channelName,
                importance: Importance.high,
                priority: Priority.high,
                icon: 'ic_notif',
              ),
            ),
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
          );
          debugPrint("HabitX: Armed exact weekly briefing '$titleLabel' for weekday $day at $scheduledDate");
        } catch (e) {
          debugPrint("HabitX: Exact weekly briefing scheduling failed for weekday $day, trying inexact fallback: $e");
          try {
            await _notifications.zonedSchedule(
              id: id,
              title: "$titlePrefix: $titleLabel",
              body: bodyText,
              scheduledDate: scheduledDate,
              notificationDetails: NotificationDetails(
                android: AndroidNotificationDetails(
                  _briefingChannelId,
                  channelName,
                  importance: Importance.high,
                  priority: Priority.high,
                  icon: 'ic_notif',
                ),
              ),
              androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
              matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
            );
            debugPrint("HabitX: Armed inexact weekly briefing '$titleLabel' for weekday $day at $scheduledDate");
          } catch (innerErr) {
            debugPrint("HabitX Critical: Failed to schedule fallback weekly briefing for weekday $day: $innerErr");
          }
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
        fullScreenIntent: false, // Wakes lockscreen
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

  tz.TZDateTime _nextInstanceOfWeekdayTime(int weekday, int hour, int minute) {
    tz.TZDateTime scheduledDate = _nextInstanceOfTime(hour, minute);
    while (scheduledDate.weekday != weekday) {
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
    final int baseId = (100000 + (habitId.hashCode.abs() % 100000));
    await _notifications.cancel(id: baseId);
    await _notifications.cancel(id: baseId + 10);
  }

  Future<void> cancelDailyBriefings() async {
    // Cancel old ids (7001 to 7004)
    final legacyIds = [7001, 7002, 7003, 7004];
    for (var id in legacyIds) {
      await _notifications.cancel(id: id);
    }
    // Cancel weekly day of week ids (Morning: 7001 to 7007, Evening: 7011 to 7017)
    for (int day = 1; day <= 7; day++) {
      await _notifications.cancel(id: 7000 + day);
      await _notifications.cancel(id: 7010 + day);
    }
    debugPrint("HabitX: Daily Briefings cancelled.");
  }

  Future<void> cancelAll() async => await _notifications.cancelAll();
}
