import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../domain/models/habit.dart';
import '../core/utils/haptic_feedback_helper.dart';
import '../data/services/storage_service.dart';
import '../data/services/home_widget_service.dart';
import '../data/services/notifications/habit_x_notification_service.dart';
import '../presentation/widgets/shared/level_up_overlay.dart';

class HabitProvider extends ChangeNotifier {
  // --- Core State ---
  final List<Habit> _allHabits = [];
  int _userXP = 0;
  int _userLevel = 1;

  // --- Identity & Achievements ---
  String _userName = "";
  int _userAge = 18;
  String _userPersona = "Professional";
  bool _isNewUser = true;
  List<String> _unlockedAchievementIds = [];

  // --- Preferences & Calendar ---
  bool _isHapticsEnabled = true;
  bool _isDailyMotivationEnabled = true;
  DateTime _selectedDate = DateTime.now();
  List<DateTime> _pastWeekDates = [];

  // --- Timer State ---
  Timer? _timer;
  int _currentSeconds = 0;
  bool _isTimerRunning = false;
  String? _activeHabitId;

  final StorageService _storage = StorageService();

  // For triggering overlays without passing BuildContext through every logic layer
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  HabitProvider() {
    _generatePastWeekDates();
  }

  // --- Real-Time Getters ---

  List<Habit> get habits {
    return _allHabits.where((habit) {
      // Show habits that were created ON OR BEFORE the selected date
      return habit.createdAt.isBefore(
        DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          23,
          59,
          59,
        ),
      );
    }).toList();
  }

  List<Habit> get allHabits => List.unmodifiable(_allHabits);
  List<String> get unlockedAchievementIds => _unlockedAchievementIds;
  int get userXP => _userXP;
  int get userLevel => _userLevel;
  String get userName => _userName;
  int get userAge => _userAge;
  String get userPersona => _userPersona;
  bool get isNewUser => _isNewUser;
  bool get isHapticsEnabled => _isHapticsEnabled;
  bool get isDailyMotivationEnabled => _isDailyMotivationEnabled;
  DateTime get selectedDate => _selectedDate;
  List<DateTime> get pastWeekDates => _pastWeekDates;
  int get currentSeconds => _currentSeconds;
  bool get isTimerRunning => _isTimerRunning;
  double get levelProgress => (_userXP % 100) / 100;

  Habit? get currentActiveHabit {
    if (_allHabits.isEmpty) return null;
    try {
      // Prioritize the last incomplete habit for the current selected date
      return habits.lastWhere((h) => !h.isCompleted);
    } catch (_) {
      // Fallback to the last habit of the day
      return habits.isNotEmpty ? habits.last : null;
    }
  }

  double get dailyProgress {
    final dayHabits = habits;
    if (dayHabits.isEmpty) return 0.0;
    return dayHabits.where((h) => h.isCompleted).length / dayHabits.length;
  }

  double get todayProgress => dailyProgress;

  // --- Neural Initialization Engine ---

  Future<void> init() async {
    _isNewUser = await _storage.isNewUser();
    _userName = await _storage.getUserName() ?? "RECRUIT";
    _userAge = await _storage.getUserAge() ?? 18;
    _userPersona = await _storage.getUserPersona() ?? "Professional";

    final progress = await _storage.loadProgress();
    _userXP = progress['xp'] ?? 0;
    _userLevel = progress['level'] ?? 1;

    _unlockedAchievementIds = await _storage.loadUnlockedAchievements();
    _isHapticsEnabled = await _storage.loadHapticPreference();
    _isDailyMotivationEnabled = await _storage.loadDailyMotivationPreference();

    final loadedHabits = await _storage.loadHabits();
    _allHabits.clear();

    // 🚀 DAILY RESET ENGINE
    final now = DateTime.now();
    bool needsSave = false;

    for (var habit in loadedHabits) {
      bool isDifferentDay =
          habit.lastCompleted.year != now.year ||
          habit.lastCompleted.month != now.month ||
          habit.lastCompleted.day != now.day;

      if (habit.isCompleted && isDifferentDay) {
        _allHabits.add(habit.copyWith(isCompleted: false));
        needsSave = true;
      } else {
        _allHabits.add(habit);
      }
    }

    if (needsSave) {
      await _storage.saveHabits(_allHabits);
    }

    // Initialize Overlord Engine
    await HabitXNotificationService().init();

    // 🛰️ STRATEGIC RE-SYNC: Force-reschedules all habits
    await refreshAllNotifications();

    _updateHomeWidget();
    notifyListeners();
  }

  Future<void> refreshAllNotifications() async {
    final notificationService = HabitXNotificationService();
    final activeHabits = _allHabits.where((h) => h.reminderTime != null);

    for (var habit in activeHabits) {
      await notificationService.scheduleHabitReminder(
        habit.id,
        habit.name,
        habit.reminderTime!,
      );
    }

    if (_isDailyMotivationEnabled) {
      await notificationService.scheduleDailyBriefings();
    } else {
      await notificationService.cancelDailyBriefings();
    }

    debugPrint(
      "HabitX: Neural Re-sync complete for ${activeHabits.length} habits.",
    );
  }

  // --- Achievement & Milestone Engine ---

  void _unlockAchievement(
    BuildContext context,
    String id,
    String title,
    dynamic icon,
    int xpReward,
  ) {
    if (!_unlockedAchievementIds.contains(id)) {
      _unlockedAchievementIds.add(id);
      _applyGamification(xpReward);
      _storage.saveUnlockedAchievements(_unlockedAchievementIds);

      _showEliteUnlockDialog(context, title, icon);
      notifyListeners();
    }
  }

  void checkMilestones(BuildContext context) {
    final int totalDone = _allHabits.where((h) => h.isCompleted).length;
    final int maxStreak = _allHabits.isEmpty
        ? 0
        : _allHabits.map((h) => h.streak).reduce((a, b) => a > b ? a : b);

    if (totalDone >= 1) {
      _unlockAchievement(
        context,
        'initiate',
        "INITIATE",
        FontAwesomeIcons.rocket,
        100,
      );
    }
    if (maxStreak >= 3) {
      _unlockAchievement(
        context,
        'momentum',
        "MOMENTUM",
        FontAwesomeIcons.fire,
        150,
      );
    }
    if (maxStreak >= 7) {
      _unlockAchievement(
        context,
        'focus',
        "DEEP FOCUS",
        FontAwesomeIcons.brain,
        300,
      );
    }
    if (totalDone >= 50) {
      _unlockAchievement(
        context,
        'guardian',
        "GUARDIAN",
        FontAwesomeIcons.shieldHalved,
        500,
      );
    }
  }

  // --- Identity Actions ---

  Future<void> setupUser({
    required String name,
    required int age,
    required String persona,
  }) async {
    _userName = name;
    _userAge = age;
    _userPersona = persona;
    _isNewUser = false;
    await _storage.saveUserIdentity(name: name, age: age, persona: persona);

    // Initial system handshake
    await HabitXNotificationService().requestPermissions();
    await HabitXNotificationService().scheduleDailyBriefings();

    _updateHomeWidget();
    notifyListeners();
  }

  Future<void> updateName(String newName) async {
    _userName = newName;
    await _storage.saveUserIdentity(
      name: _userName,
      age: _userAge,
      persona: _userPersona,
    );
    _updateHomeWidget();
    notifyListeners();
  }

  Future<void> resetUserIdentity() async {
    _userName = "RECRUIT";
    _userAge = 18;
    _userPersona = "Professional";
    _isNewUser = true;
    await _storage.saveUserIdentity(name: "", age: 18, persona: "Professional");
    _updateHomeWidget();
    notifyListeners();
  }

  // --- Preference Actions ---

  void toggleHaptics(bool value) {
    _isHapticsEnabled = value;
    _storage.saveHapticPreference(value);
    notifyListeners();
  }

  Future<void> toggleDailyMotivation(bool value) async {
    _isDailyMotivationEnabled = value;
    await _storage.saveDailyMotivationPreference(value);
    if (value) {
      await HabitXNotificationService().scheduleDailyBriefings();
    } else {
      await HabitXNotificationService().cancelDailyBriefings();
    }
    notifyListeners();
  }

  // --- Calendar Logic ---

  void _generatePastWeekDates() {
    _pastWeekDates = List.generate(7, (index) {
      return DateTime.now().subtract(Duration(days: index));
    }).reversed.toList();
  }

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    _updateHomeWidget();
    notifyListeners();
  }

  // --- Real-Time Timer Engine ---

  void startTaskTimer(String habitId, int minutes) {
    _timer?.cancel();
    _activeHabitId = habitId;
    _currentSeconds = minutes * 60;
    _resumeCountdown();
    notifyListeners();
  }

  void toggleTimer(int initialMinutes) {
    if (_isTimerRunning) {
      _timer?.cancel();
      _isTimerRunning = false;
    } else {
      if (_currentSeconds <= 0) {
        _currentSeconds = initialMinutes * 60;
      }
      _resumeCountdown();
    }
    notifyListeners();
  }

  void _resumeCountdown() {
    _isTimerRunning = true;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentSeconds > 0) {
        _currentSeconds--;
        notifyListeners();
      } else {
        _handleTimerCompletion();
      }
    });
  }

  void sendTestNotification() {
    HabitXNotificationService().showInstantNotification(
      title: "Neural Sync Complete ⚡",
      body: "Overlord Engine is active and monitoring.",
    );
    if (_isHapticsEnabled) HapticHelper.lightTap();
  }

  void addSeconds(int seconds) {
    _currentSeconds += seconds;
    if (_currentSeconds < 0) _currentSeconds = 0;
    notifyListeners();
  }

  void stopTimer() {
    _isTimerRunning = false;
    _timer?.cancel();
    notifyListeners();
  }

  void _handleTimerCompletion() {
    stopTimer();
    if (_isHapticsEnabled) HapticHelper.success();

    HabitXNotificationService().showInstantNotification(
      title: "Objective Secured 🏆",
      body: "Task complete. Status: ELITE.",
    );

    if (_activeHabitId != null && navigatorKey.currentContext != null) {
      toggleHabitCompletion(navigatorKey.currentContext!, _activeHabitId!);
      _activeHabitId = null;
    }
  }

  // --- Local Data Management ---

  void addHabit(Habit habit) {
    _allHabits.add(habit);
    _storage.saveHabits(_allHabits);

    if (habit.reminderTime != null) {
      HabitXNotificationService().scheduleHabitReminder(
        habit.id,
        habit.name,
        habit.reminderTime!,
      );
    }

    _updateHomeWidget();
    notifyListeners();
  }

  void updateHabit(Habit updatedHabit) {
    final index = _allHabits.indexWhere((h) => h.id == updatedHabit.id);
    if (index != -1) {
      _allHabits[index] = updatedHabit;
      _storage.saveHabits(_allHabits);

      if (updatedHabit.reminderTime != null) {
        HabitXNotificationService().scheduleHabitReminder(
          updatedHabit.id,
          updatedHabit.name,
          updatedHabit.reminderTime!,
        );
      } else {
        HabitXNotificationService().cancelReminder(updatedHabit.id);
      }

      _updateHomeWidget();
      notifyListeners();
    }
  }

  void deleteHabit(String id) {
    _allHabits.removeWhere((h) => h.id == id);
    _storage.saveHabits(_allHabits);

    HabitXNotificationService().cancelReminder(id);

    _updateHomeWidget();
    notifyListeners();
  }

  void toggleHabitCompletion(BuildContext context, String id) {
    final index = _allHabits.indexWhere((h) => h.id == id);
    if (index == -1) return;

    final habit = _allHabits[index];
    final bool isNowCompleted = !habit.isCompleted;
    final List<DateTime> updatedCompletedDates = List.from(habit.completedDates);
    final now = DateTime.now();
    final todayStr = "${now.year}-${now.month}-${now.day}";

    if (isNowCompleted) {
      if (_isHapticsEnabled) HapticHelper.success();
      _applyGamification(habit.xpValue);
      checkMilestones(context);

      HabitXNotificationService().showInstantNotification(
        title: "Mission Accomplished 🏆",
        body: "Goal '${habit.name}' verified. XP secured.",
      );

      bool alreadyAdded = updatedCompletedDates.any(
        (d) => "${d.year}-${d.month}-${d.day}" == todayStr,
      );
      if (!alreadyAdded) {
        updatedCompletedDates.add(now);
      }
    } else {
      _reverseGamification(habit.xpValue);
      updatedCompletedDates.removeWhere(
        (d) => "${d.year}-${d.month}-${d.day}" == todayStr,
      );
    }

    _allHabits[index] = habit.copyWith(
      isCompleted: isNowCompleted,
      streak: isNowCompleted
          ? habit.streak + 1
          : (habit.streak > 0 ? habit.streak - 1 : 0),
      lastCompleted: now,
      completedDates: updatedCompletedDates,
    );

    _storage.saveHabits(_allHabits);
    _updateHomeWidget();
    notifyListeners();
  }

  void setAiTimer(int minutes) {
    _currentSeconds = minutes * 60;
    _timer?.cancel();
    _isTimerRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentSeconds > 0) {
        _currentSeconds--;
        notifyListeners();
      } else {
        _handleTimerCompletion();
      }
    });
    notifyListeners();
  }

  void triggerXpReport() {
    HapticHelper.success();
    notifyListeners();
  }

  // --- Home Widget Synchronization ---

  void _updateHomeWidget() {
    // minimalist sync: The service now internally handles the 3-image rotation logic based on the date.
    HomeWidgetService.updateWidget();
  }

  // --- Gamification Engine ---

  void _applyGamification(int xp) {
    _userXP += xp;
    while (_userXP >= _userLevel * 100) {
      _userLevel++;
      if (_isHapticsEnabled) HapticHelper.levelUp();

      if (navigatorKey.currentContext != null) {
        LevelUpOverlay.show(navigatorKey.currentContext!, _userLevel);
      }
    }
    _storage.saveProgress(_userXP, _userLevel);
    _updateHomeWidget();
  }

  void _reverseGamification(int xp) {
    _userXP = (_userXP - xp).clamp(0, 1000000);
    _storage.saveProgress(_userXP, _userLevel);
    _updateHomeWidget();
  }

  // --- Elite Achievement UI ---

  void _showEliteUnlockDialog(
    BuildContext context,
    String title,
    dynamic icon,
  ) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Achievement",
      barrierColor: Colors.black.withOpacity(0.9),
      transitionDuration: const Duration(milliseconds: 600),
      pageBuilder: (context, anim1, anim2) => Center(
        child: GlassmorphicContainer(
          width: MediaQuery.of(context).size.width * 0.85,
          height: 420,
          borderRadius: 40,
          blur: 30,
          alignment: Alignment.center,
          border: 2,
          linearGradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.1),
              Colors.white.withOpacity(0.05),
            ],
          ),
          borderGradient: const LinearGradient(
            colors: [Color(0xFFAC5DED), Colors.transparent],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildGlowingIcon(icon),
              const SizedBox(height: 40),
              const Text(
                "MISSION ACCOMPLISHED",
                style: TextStyle(
                  color: Color(0xFFAC5DED),
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 4,
                  decoration: TextDecoration.none,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  decoration: TextDecoration.none,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFAC5DED),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 18,
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "RECEIVE REWARD",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlowingIcon(dynamic icon) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFAC5DED).withOpacity(0.6),
                blurRadius: 40,
                spreadRadius: 5,
              ),
            ],
          ),
        ),
        FaIcon(icon, color: Colors.white, size: 50),
      ],
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
