import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../../domain/models/habit.dart';
import '../../core/utils/haptic_feedback_helper.dart';
import '../../data/services/storage_service.dart';
import '../core/utils/mission_timer_engine.dart';
import '../data/services/notification_master.dart';
import '../presentation/widgets/shared/level_up_overlay.dart';

class HabitProvider extends ChangeNotifier {
  // --- Core State ---
  final List<Habit> _allHabits = [];
  int _userXP = 0;
  int _userLevel = 1;

  // --- Identity & Achievements ---
  String _userName = "";
  bool _isNewUser = true;
  List<String> _unlockedAchievementIds = []; // PERSISTENT STORAGE

  // --- Preferences & Calendar ---
  bool _isHapticsEnabled = true;
  DateTime _selectedDate = DateTime.now();
  List<DateTime> _pastWeekDates = [];

  // --- Timer State ---
  late MissionTimerEngine _timerEngine;
  int _displaySeconds = 0;
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
      return habit.createdAt.year == _selectedDate.year &&
          habit.createdAt.month == _selectedDate.month &&
          habit.createdAt.day == _selectedDate.day;
    }).toList();
  }

  List<Habit> get allHabits => List.unmodifiable(_allHabits);
  List<String> get unlockedAchievementIds => _unlockedAchievementIds;
  int get userXP => _userXP;
  int get userLevel => _userLevel;
  String get userName => _userName;
  bool get isNewUser => _isNewUser;
  bool get isHapticsEnabled => _isHapticsEnabled;
  DateTime get selectedDate => _selectedDate;
  List<DateTime> get pastWeekDates => _pastWeekDates;
  int get currentSeconds => _currentSeconds;
  bool get isTimerRunning => _isTimerRunning;
  double get levelProgress => (_userXP % 100) / 100;

  double get todayProgress {
    final dayHabits = habits;
    if (dayHabits.isEmpty) return 0.0;
    return dayHabits.where((h) => h.isCompleted).length / dayHabits.length;
  }

  // --- Serverless Initialization ---

  Future<void> init() async {
    _isNewUser = await _storage.isNewUser();
    _userName = await _storage.getUserName() ?? "";

    final progress = await _storage.loadProgress();
    _userXP = progress['xp'] ?? 0;
    _userLevel = progress['level'] ?? 1;

    // Load persistent achievements from disk
    _unlockedAchievementIds = await _storage.loadUnlockedAchievements();

    final loadedHabits = await _storage.loadHabits();
    _allHabits.clear();
    _allHabits.addAll(loadedHabits);

    notifyListeners();
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
      _applyGamification(xpReward); // Reward bonus XP
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

    if (totalDone >= 1)
      _unlockAchievement(
        context,
        'initiate',
        "INITIATE",
        FontAwesomeIcons.rocket,
        100,
      );
    if (maxStreak >= 3)
      _unlockAchievement(
        context,
        'momentum',
        "MOMENTUM",
        FontAwesomeIcons.fire,
        150,
      );
    if (maxStreak >= 7)
      _unlockAchievement(
        context,
        'focus',
        "DEEP FOCUS",
        FontAwesomeIcons.brain,
        300,
      );
    if (totalDone >= 50)
      _unlockAchievement(
        context,
        'guardian',
        "GUARDIAN",
        FontAwesomeIcons.shieldHalved,
        500,
      );
  }

  // --- Identity Actions ---

  Future<void> setupUser(String name) async {
    _userName = name;
    _isNewUser = false;
    await _storage.saveUserIdentity(name);
    notifyListeners();
  }

  Future<void> updateName(String newName) async {
    _userName = newName;
    await _storage.saveUserIdentity(newName);
    notifyListeners();
  }

  Future<void> resetUserIdentity() async {
    _userName = "";
    _isNewUser = true;
    await _storage.saveUserIdentity("");
    notifyListeners();
  }

  // --- Preference Actions ---

  void toggleHaptics(bool value) {
    _isHapticsEnabled = value;
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

  // Inside HabitProvider class

  // Inside HabitProvider class

  void sendTestNotification() {
    // Use the updated manager without the 'id' parameter
    HabitXNotificationManager().scheduleHabitTask(
      habitName: "Elite Mission Test",
      actionGoal: "Testing system response...",
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

    // Trigger immediate completion notification
    HabitXNotificationManager().scheduleHabitTask(
      habitName: "Timer Complete",
      actionGoal: "Mission Accomplished!",
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
      // 1. Schedule the EXACT time notification
      HabitXNotificationManager().scheduleDelayedTask(
        habitName: habit.name,
        targetTime: habit.reminderTime!,
        minutesBefore: 0, // Exact time
      );

      // 2. Schedule the 2-MINUTE WARNING notification
      HabitXNotificationManager().scheduleDelayedTask(
        habitName: habit.name,
        targetTime: habit.reminderTime!,
        minutesBefore: 2, // 2 minutes before
      );
    }

    notifyListeners();
  }

  void deleteHabit(String id) {
    _allHabits.removeWhere((h) => h.id == id);
    _storage.saveHabits(_allHabits);
    notifyListeners();
  }

  void toggleHabitCompletion(BuildContext context, String id) {
    final index = _allHabits.indexWhere((h) => h.id == id);
    if (index == -1) return;

    final habit = _allHabits[index];
    final bool isNowCompleted = !habit.isCompleted;

    if (isNowCompleted) {
      if (_isHapticsEnabled) HapticHelper.success();
      _applyGamification(habit.xpValue);
      checkMilestones(context);
    } else {
      _reverseGamification(habit.xpValue);
    }

    _allHabits[index] = habit.copyWith(
      isCompleted: isNowCompleted,
      streak: isNowCompleted
          ? habit.streak + 1
          : (habit.streak > 0 ? habit.streak - 1 : 0),
      lastCompleted: DateTime.now(),
    );

    _storage.saveHabits(_allHabits);
    notifyListeners();
  }
  // Inside HabitProvider.dart

  // Function to set the timer directly from AI suggestions
  void setAiTimer(int minutes) {
    // 1. Reset current seconds to the AI suggested duration
    _currentSeconds = minutes * 60;

    // 2. Stop any existing timer before starting a new one
    _timer?.cancel();

    _isTimerRunning = true;

    // 3. Start the periodic ticker
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentSeconds > 0) {
        _currentSeconds--;
        notifyListeners();
      } else {
        _handleTimerCompletion(); // The method we updated earlier
      }
    });

    notifyListeners();
  }

  // Function to handle "XP Report" navigation or logic
  void triggerXpReport() {
    // You can either navigate to stats or show a quick XP summary snackbar
    // For now, let's trigger a haptic and a specific notification
    HapticHelper.success();
    notifyListeners();
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
  }

  void _reverseGamification(int xp) {
    _userXP = (_userXP - xp).clamp(0, 1000000);
    _storage.saveProgress(_userXP, _userLevel);
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
