import 'dart:async';
import 'package:flutter/material.dart';
import 'package:notification_master/notification_master.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import '../../core/constants/notification_messages.dart';

class HabitXNotificationManager {
  static final HabitXNotificationManager _instance =
      HabitXNotificationManager._internal();
  factory HabitXNotificationManager() => _instance;
  HabitXNotificationManager._internal();

  final _master = NotificationMaster();
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  /// 1. Initialize Dual Engine
  Future<void> init() async {
    bool hasPermission = await _master.checkNotificationPermission();
    if (!hasPermission) {
      await _master.requestNotificationPermission();
    }
    await _createChannels();

    tz.initializeTimeZones();
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings = InitializationSettings(
      android: androidInit,
    );
    await _localNotifications.initialize(settings: initSettings);

    await scheduleDailyCoachingLoop();
    debugPrint("HabitX: Neural Dual-Notification Engine Active");
  }

  Future<void> _createChannels() async {
    await _master.createCustomChannel(
      channelId: 'daily_motivation',
      channelName: 'Daily Motivation',
      channelDescription: 'Professional coaching and status updates',
    );
    await _master.createCustomChannel(
      channelId: 'habit_tasks',
      channelName: 'Habit Reminders',
      channelDescription: 'Exact triggers for your habit execution',
    );
  }

  /// 2. Daily Strategic Windows
  Future<void> scheduleDailyCoachingLoop() async {
    final List<Map<String, dynamic>> windows = [
      {'id': 101, 'hour': 9, 'min': 0, 'title': 'Morning Briefing'},
      {'id': 102, 'hour': 14, 'min': 30, 'title': 'Mid-Day Audit'},
      {'id': 103, 'hour': 19, 'min': 0, 'title': 'Evening Push'},
      {'id': 104, 'hour': 21, 'min': 30, 'title': 'Nightly Reflection'},
    ];

    for (var window in windows) {
      // USING NAMED PARAMETERS EXPLICITLY TO SATISFY COMPILER
      await _localNotifications.zonedSchedule(
        id: window['id'],
        title: 'SHELBY AI: ${window['title']}',
        body: NotificationMessages.randomCoachPrompt,
        scheduledDate: _nextInstanceOfTime(window['hour'], window['min']),
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'daily_motivation',
            'Daily Motivation',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

  /// 3. Instant Master Notifications
  Future<void> triggerDailyMotivation() async {
    await _master.showBigTextNotification(
      title: 'SHELBY AI: Status Check',
      message: 'Status: Optimal',
      bigText: NotificationMessages.randomCoachPrompt,
    );
  }

  Future<void> scheduleHabitTask({
    required String habitName,
    required String actionGoal,
  }) async {
    await _master.showHeadsUpNotification(
      title: 'Mission: $habitName',
      message: 'Objective: $actionGoal. Execute now.',
    );
  }

  /// 4. Robust Delayed Scheduling
  Future<void> scheduleDelayedTask({
    required String habitName,
    required DateTime targetTime,
    int minutesBefore = 0,
  }) async {
    final scheduledTime = targetTime.subtract(Duration(minutes: minutesBefore));
    if (scheduledTime.isBefore(DateTime.now())) return;

    final int missionId = (targetTime.millisecondsSinceEpoch ~/ 60000).toInt();

    // USING NAMED PARAMETERS EXPLICITLY
    await _localNotifications.zonedSchedule(
      id: missionId,
      title: minutesBefore > 0 ? "Upcoming: $habitName" : "Mission: $habitName",
      body: minutesBefore > 0
          ? "Starts in $minutesBefore minutes."
          : "Time to execute.",
      scheduledDate: tz.TZDateTime.from(scheduledTime, tz.local),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'habit_tasks',
          'Habit Reminders',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
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

  Future<void> sendInstantTest() async {
    await _master.showBigTextNotification(
      title: 'HabitX Connection',
      message: 'System Online',
      bigText: 'Telemetry verified. Dual-Engine is Live.',
    );
  }
}
