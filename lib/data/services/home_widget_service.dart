import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'storage_service.dart';
import '../../domain/models/habit.dart';
import '../../core/utils/habit_completion_handler.dart';
import 'notifications/habit_x_notification_service.dart';

class HomeWidgetService {
  // FIXED: Removed the package name prefix to prevent the ClassNotFound double-package error
  static const String _androidWidgetName = 'HabitWidgetProvider';
  static const String _groupId = 'group.habitx_glass_data';

  /// Initializes the Home Widget service.
  static Future<void> init() async {
    await HomeWidget.setAppGroupId(_groupId);
  }

  /// Updates the Home Widget with the optimized daily rotating image, streak, and user status.
  static Future<void> updateWidget({
    int streak = 0,
    int level = 1,
    int completedCount = 0,
    int totalCount = 0,
    List<Habit> habits = const [],
  }) async {
    try {
      final now = DateTime.now();

      // Calculate Daily Image Index (1, 2, or 3)
      final imageIndex = (now.day % 3) + 1;
      final String assetPath = 'assets/images/habitx$imageIndex.png';

      debugPrint("HabitX Neural Sync: Rotating daily artwork -> $assetPath with streak: $streak, Lvl: $level, progress: $completedCount/$totalCount");

      final renderWidget = Directionality(
        textDirection: TextDirection.ltr,
        child: Container(
          width: 100,
          height: 100,
          color: Colors.transparent,
          child: Stack(
            children: [
              ClipPath(
                clipper: WidgetCardClipper(),
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: Color(0xE61A1A1A), // Dark glass base matching theme
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Image.asset(assetPath, fit: BoxFit.contain),
                    ),
                  ),
                ),
              ),
              CustomPaint(
                size: const Size(100, 100),
                painter: WidgetCardBorderPainter(),
              ),
              // Level Badge (Top-Left Corner)
              Positioned(
                top: 6,
                left: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                  decoration: BoxDecoration(
                    color: const Color(0xFFAC5DED).withValues(alpha: 0.8), // Brand purple
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    "L$level",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 6,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ),
              // Bottom row containing Streak and Completion status badges
              Positioned(
                bottom: 6,
                left: 4,
                right: 4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Streak Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        color: const Color(0xE6FF5722), // Fire color
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                          width: 0.4,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "🔥",
                            style: TextStyle(
                              fontSize: 6.5,
                              color: Colors.white,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          const SizedBox(width: 1),
                          Text(
                            "$streak",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 6.5,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'monospace',
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Completion Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00E5FF).withValues(alpha: 0.75), // Cyan progress
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                          width: 0.4,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "🎯",
                            style: TextStyle(
                              fontSize: 6.5,
                              color: Colors.white,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          const SizedBox(width: 1),
                          Text(
                            "$completedCount/$totalCount",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 6.5,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'monospace',
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

      // Save basic data to shared preferences for widget access
      await HomeWidget.saveWidgetData<int>('streak', streak);
      await HomeWidget.saveWidgetData<int>('level', level);
      await HomeWidget.saveWidgetData<int>('completedCount', completedCount);
      await HomeWidget.saveWidgetData<int>('totalCount', totalCount);

      // Serialize top 3 habits
      final activeHabitsList = habits.take(3).map((h) => {
        'id': h.id,
        'name': h.name,
        'isCompleted': h.isCompleted,
        'streak': h.streak,
      }).toList();
      final String habitsJson = jsonEncode(activeHabitsList);
      await HomeWidget.saveWidgetData<String>('habits_json', habitsJson);

      // FIXED: Dropped logicalSize to 100x100.
      // This is the "Safe Zone" for Android RemoteViews memory limits.
      try {
        await HomeWidget.renderFlutterWidget(
          renderWidget,
          key: 'mascot_image',
          logicalSize: const Size(100, 100),
        );
      } catch (renderError) {
        debugPrint("HabitX Background: Mascot image rendering skipped or failed: $renderError");
      }

      // FIXED: Using only the class name to prevent the package-doubling crash
      await HomeWidget.updateWidget(
        name: _androidWidgetName,
        androidName: _androidWidgetName,
      );

      debugPrint("HabitX: Home Widget Sync Complete.");
    } catch (e) {
      debugPrint("HabitX Widget Sync Error: $e");
    }
  }

  /// Handles marking a habit complete from the interactive widget background isolate.
  @pragma('vm:entry-point')
  static Future<void> handleBackgroundCompletion(String habitId) async {
    try {
      final storage = StorageService();
      final now = DateTime.now();

      // Load data from StorageService (app's internal SharedPreferences)
      final allHabits = await storage.loadHabits();
      final progress = await storage.loadProgress();
      final currentXP = progress['xp'] ?? 0;
      final currentLevel = progress['level'] ?? 1;

      // Run shared calculation
      final result = HabitCompletionHandler.toggleCompletion(
        allHabits: allHabits,
        habitId: habitId,
        currentXP: currentXP,
        currentLevel: currentLevel,
        now: now,
      );

      // Save updated data
      await storage.saveHabits(result.updatedHabits);
      await storage.saveProgress(result.newXP, result.newLevel);

      // Update notifications
      final notificationService = HabitXNotificationService();
      await notificationService.init();
      if (result.isNowCompleted) {
        await notificationService.cancelReminder(result.updatedHabit.id);
        await notificationService.showInstantNotification(
          title: "Mission Accomplished 🏆",
          body: "Goal '${result.updatedHabit.name}' verified. XP secured.",
        );
      } else {
        if (result.updatedHabit.reminderTime != null) {
          await notificationService.scheduleHabitReminder(
            result.updatedHabit.id,
            result.updatedHabit.name,
            result.updatedHabit.reminderTime!,
            createdAt: result.updatedHabit.createdAt,
          );
        }
      }

      // Update widget data & update widget UI
      final todayHabits = result.updatedHabits.where((habit) {
        return habit.createdAt.isBefore(
          DateTime(now.year, now.month, now.day, 23, 59, 59),
        );
      }).toList();

      final int maxStreak = result.updatedHabits.isEmpty
          ? 0
          : result.updatedHabits.map((h) => h.streak).reduce((a, b) => a > b ? a : b);
      final int completedCount = todayHabits.where((h) => h.isCompleted).length;
      final int totalCount = todayHabits.length;

      // Update App Group ID and refresh native widget state
      await HomeWidget.setAppGroupId(_groupId);
      await updateWidget(
        streak: maxStreak,
        level: result.newLevel,
        completedCount: completedCount,
        totalCount: totalCount,
        habits: todayHabits,
      );

      debugPrint("HabitX Background Completion Sync Successful for: $habitId");
    } catch (e) {
      debugPrint("HabitX Background Completion Sync Error: $e");
    }
  }
}

class WidgetCardClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final double r = 16.0; // border radius of corners
    final double notchSize = 36.0; // size of the top-right cutout

    // Start at top-left corner
    path.moveTo(r, 0);
    
    // Line to the start of the notch
    path.lineTo(size.width - notchSize - r, 0);
    
    // Notch curve down
    path.quadraticBezierTo(
      size.width - notchSize,
      0,
      size.width - notchSize,
      r,
    );
    path.lineTo(size.width - notchSize, notchSize - r);
    
    // Notch curve right
    path.quadraticBezierTo(
      size.width - notchSize,
      notchSize,
      size.width - notchSize + r,
      notchSize,
    );
    path.lineTo(size.width - r, notchSize);
    
    // Curve down to right edge
    path.quadraticBezierTo(
      size.width,
      notchSize,
      size.width,
      notchSize + r,
    );
    
    // Down right edge
    path.lineTo(size.width, size.height - r);
    
    // Bottom-right corner
    path.quadraticBezierTo(
      size.width,
      size.height,
      size.width - r,
      size.height,
    );
    
    // Bottom edge
    path.lineTo(r, size.height);
    
    // Bottom-left corner
    path.quadraticBezierTo(
      0,
      size.height,
      0,
      size.height - r,
    );
    
    // Left edge
    path.lineTo(0, r);
    
    // Top-left corner
    path.quadraticBezierTo(
      0,
      0,
      r,
      0,
    );
    
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class WidgetCardBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final path = WidgetCardClipper().getClip(size);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
