import 'dart:async';
import 'package:flutter/material.dart';
import '../domain/models/habit.dart';
import '../domain/models/shelby_persona.dart';
import '../core/utils/haptic_feedback_helper.dart';
import '../core/utils/streak_engine.dart';
import '../core/utils/xp_level_calculator.dart';
import '../core/utils/habit_stacking_validator.dart';
import '../core/utils/milestone_checker.dart';
import '../presentation/widgets/shared/achievement_overlay_helper.dart';
import '../data/services/storage_service.dart';
import '../data/services/home_widget_service.dart';
import '../data/services/notifications/habit_x_notification_service.dart';
import '../presentation/widgets/shared/level_up_overlay.dart';
import '../core/constants/notification_messages.dart';
import '../core/constants/avatar_constants.dart';
import '../core/utils/habit_completion_handler.dart';

class HabitProvider extends ChangeNotifier with WidgetsBindingObserver {
  // --- Core State ---
  final List<Habit> _allHabits = [];
  int _userXP = 0;
  int _userLevel = 1;
  // --- Identity & Achievements ---
  String _userName = "";
  int _userAge = 18;
  String _userPersona = "Professional";
  String _userAvatar = "Neon Runner";
  String _userGender = "Male";
  bool _isNewUser = true;
  List<String> _unlockedAchievementIds = [];
  // --- Preferences & Calendar ---
  bool _isHapticsEnabled = true;
  bool _isDailyMotivationEnabled = true;
  bool _isReduceMotionActive = false;
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
    WidgetsBinding.instance.addObserver(this);
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
  String get userAvatar => _userAvatar;
  String get userAvatarSvgPath {
    final avatar = _userAvatar;
    if (avatar.endsWith('.svg')) {
      return 'assets/profile svg icons/$avatar';
    }
    switch (avatar) {
      case 'Neon Runner':
        return 'assets/profile svg icons/fox.svg';
      case 'Cyborg Sentinel':
        return 'assets/profile svg icons/bear.svg';
      case 'Zen Architect':
        return 'assets/profile svg icons/panda.svg';
      case 'Data Scribe':
        return 'assets/profile svg icons/penguin.svg';
      case 'Solar Pioneer':
        return 'assets/profile svg icons/lion.svg';
      case 'Quantum Druid':
        return 'assets/profile svg icons/cat.svg';
      default:
        return 'assets/profile svg icons/panda.svg';
    }
  }

  String get userAvatarDisplayName => AvatarConstants.getDisplayName(_userAvatar);
  String get userGender => _userGender;
  bool get isNewUser => _isNewUser;
  bool get isHapticsEnabled => _isHapticsEnabled;
  bool get isDailyMotivationEnabled => _isDailyMotivationEnabled;
  bool get isReduceMotionActive => _isReduceMotionActive;

  ShelbyPersona get activePersona {
    switch (_userPersona.toLowerCase()) {
      case 'flirty':
        return ShelbyPersona.flirty;
      case 'roast':
        return ShelbyPersona.roast;
      case 'cute':
        return ShelbyPersona.cute;
      case 'romantic':
        return ShelbyPersona.romantic;
      case 'breakup':
        return ShelbyPersona.breakup;
      case 'discipline':
        return ShelbyPersona.discipline;
      case 'genz':
        return ShelbyPersona.genz;
      case 'overlord':
      case 'shelby ai':
      case 'shelby':
        return ShelbyPersona.overlord;
      case 'professional':
      case 'elite':
      case 'motivational':
      default:
        return ShelbyPersona.motivational;
    }
  }

  DateTime get selectedDate => _selectedDate;
  List<DateTime> get pastWeekDates => _pastWeekDates;
  int get currentSeconds => _currentSeconds;
  bool get isTimerRunning => _isTimerRunning;
  double get levelProgress => XpLevelCalculator.getLevelProgress(_userXP);

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

  Future<void> init() async {
    _isNewUser = await _storage.isNewUser();
    _userName = await _storage.getUserName() ?? "RECRUIT";
    _userAge = await _storage.getUserAge() ?? 18;
    _userPersona = await _storage.getUserPersona() ?? "Professional";
    _userAvatar = await _storage.getUserAvatar() ?? "Neon Runner";
    _userGender = await _storage.getUserGender() ?? "Male";
    final progress = await _storage.loadProgress();
    _userXP = progress['xp'] ?? 0;
    _userLevel = progress['level'] ?? 1;

    _unlockedAchievementIds = await _storage.loadUnlockedAchievements();
    _isHapticsEnabled = await _storage.loadHapticPreference();
    _isDailyMotivationEnabled = await _storage.loadDailyMotivationPreference();
    _isReduceMotionActive = await _storage.loadReduceMotionPreference();

    final loadedHabits = await _storage.loadHabits();
    _allHabits.clear();

    // 🚀 DAILY RESET ENGINE & STREAK DECAY
    final now = DateTime.now();
    bool needsSave = false;

    for (var habit in loadedHabits) {
      Habit processedHabit = StreakEngine.processDailyResetAndStreakDecay(habit, now);
      if (processedHabit != habit) {
        needsSave = true;
      }
      _allHabits.add(processedHabit);
    }

    if (needsSave) {
      await _storage.saveHabits(_allHabits);
    }

    _checkAndReplenishFreezes();

    // Initialize Overlord Engine & reschedule notifications in the background
    HabitXNotificationService().init().then((_) {
      refreshAllNotifications();
    });

    _updateHomeWidget();
    notifyListeners();
  }

  Future<void> refreshAllNotifications() async {
    final notificationService = HabitXNotificationService();
    final activeHabits = _allHabits.where((h) => h.reminderTime != null);

    for (var habit in activeHabits) {
      if (habit.isCompleted) {
        await notificationService.cancelReminder(habit.id);
      } else {
        await notificationService.scheduleHabitReminder(
          habit.id,
          habit.name,
          habit.reminderTime!,
          createdAt: habit.createdAt,
        );
      }
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

      AchievementOverlayHelper.showEliteUnlockDialog(context, title, icon);
      notifyListeners();
    }
  }

  void checkMilestones(BuildContext context) {
    MilestoneChecker.checkMilestones(
      allHabits: _allHabits,
      userLevel: _userLevel,
      unlockedAchievementIds: _unlockedAchievementIds,
      onUnlock: (id, title, icon, xpReward) {
        _unlockAchievement(context, id, title, icon, xpReward);
      },
    );
  }

  // --- Identity Actions ---

  Future<void> setupUser({
    required String name,
    required int age,
    required String persona,
    String gender = "Male",
  }) async {
    _userName = name;
    _userAge = age;
    _userPersona = persona;
    _userGender = gender;
    _isNewUser = false;
    await _storage.saveUserIdentity(name: name, age: age, persona: persona);
    await _storage.saveUserGender(gender);

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
  Future<void> updatePersona(String newPersona) async {
    _userPersona = newPersona;
    await _storage.saveUserIdentity(
      name: _userName,
      age: _userAge,
      persona: _userPersona,
    );
    if (_isDailyMotivationEnabled) {
      await HabitXNotificationService().scheduleDailyBriefings();
    }

    // Send immediate notification on change
    await HabitXNotificationService().showInstantNotification(
      title: NotificationMessages.getStatusTitle(newPersona),
      body: "Notification theme updated to ${newPersona == 'Overlord' ? 'SHELBY AI' : newPersona}. ${NotificationMessages.getStatusBody(newPersona)}",
    );

    _updateHomeWidget();
    notifyListeners();
  }
  Future<void> updateGender(String newGender) async {
    _userGender = newGender;
    await _storage.saveUserGender(newGender);
    if (_isDailyMotivationEnabled) {
      await HabitXNotificationService().scheduleDailyBriefings();
    }
    notifyListeners();
  }
  Future<void> resetUserIdentity() async {
    _userName = "RECRUIT";
    _userAge = 18;
    _userPersona = "Professional";
    _userGender = "Male";
    _isNewUser = true;
    _userAvatar = "Neon Runner";
    await _storage.saveUserIdentity(name: "", age: 18, persona: "Professional");
    await _storage.saveUserGender("Male");
    await _storage.saveUserAvatar("Neon Runner");
    _updateHomeWidget();
    notifyListeners();
  }

  Future<void> updateAvatar(String name) async {
    _userAvatar = name;
    await _storage.saveUserAvatar(name);
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

  void toggleReduceMotion(bool value) {
    _isReduceMotionActive = value;
    _storage.saveReduceMotionPreference(value);
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
      title: NotificationMessages.getStatusTitle(_userPersona),
      body: NotificationMessages.getStatusBody(_userPersona),
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
      if (habit.isCompleted) {
        HabitXNotificationService().cancelReminder(habit.id);
      } else {
        HabitXNotificationService().scheduleHabitReminder(
          habit.id,
          habit.name,
          habit.reminderTime!,
          createdAt: habit.createdAt,
        );
      }
    }

    _updateHomeWidget();
    notifyListeners();
  }

  void addHabits(List<Habit> habits) {
    _allHabits.addAll(habits);
    _storage.saveHabits(_allHabits);

    for (final habit in habits) {
      if (habit.reminderTime != null && !habit.isCompleted) {
        HabitXNotificationService().scheduleHabitReminder(
          habit.id,
          habit.name,
          habit.reminderTime!,
          createdAt: habit.createdAt,
        );
      }
    }

    _updateHomeWidget();
    notifyListeners();
  }

  void updateHabit(Habit updatedHabit) {
    final index = _allHabits.indexWhere((h) => h.id == updatedHabit.id);
    if (index != -1) {
      _allHabits[index] = updatedHabit;
      _storage.saveHabits(_allHabits);

      if (updatedHabit.reminderTime != null && !updatedHabit.isCompleted) {
        HabitXNotificationService().scheduleHabitReminder(
          updatedHabit.id,
          updatedHabit.name,
          updatedHabit.reminderTime!,
          createdAt: updatedHabit.createdAt,
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

    // Cascade trigger deletion: clear triggerHabitId for child habits
    for (int i = 0; i < _allHabits.length; i++) {
      if (_allHabits[i].triggerHabitId == id) {
        _allHabits[i] = _allHabits[i].copyWith(triggerHabitId: () => null);
      }
    }

    _storage.saveHabits(_allHabits);
    HabitXNotificationService().cancelReminder(id);
    _updateHomeWidget();
    notifyListeners();
  }

  void toggleHabitCompletion(BuildContext? context, String id) {
    try {
      final now = DateTime.now();
      final oldLevel = _userLevel;

      final result = HabitCompletionHandler.toggleCompletion(
        allHabits: _allHabits,
        habitId: id,
        currentXP: _userXP,
        currentLevel: _userLevel,
        now: now,
      );

      final index = _allHabits.indexWhere((h) => h.id == id);
      if (index == -1) return;

      _allHabits[index] = result.updatedHabit;
      _userXP = result.newXP;

      if (result.newLevel > oldLevel) {
        for (int l = oldLevel + 1; l <= result.newLevel; l++) {
          if (_isHapticsEnabled) HapticHelper.levelUp();
          if (navigatorKey.currentContext != null) {
            LevelUpOverlay.show(navigatorKey.currentContext!, l);
          }
        }
        _userLevel = result.newLevel;
      }

      _storage.saveProgress(_userXP, _userLevel);
      _storage.saveHabits(_allHabits);

      if (result.isNowCompleted) {
        if (_isHapticsEnabled) HapticHelper.success();
        if (context != null) {
          checkMilestones(context);
        }

        HabitXNotificationService().showInstantNotification(
          title: "Mission Accomplished 🏆",
          body: "Goal '${result.updatedHabit.name}' verified. XP secured.",
        );

        if (context != null) {
          final stackedHabits = _allHabits.where((h) => h.triggerHabitId == id && !h.isCompleted).toList();
          if (stackedHabits.isNotEmpty) {
            _showStackedNudge(context, stackedHabits.first);
          }
        }
      } else {
        if (result.updatedHabit.reminderTime != null) {
          HabitXNotificationService().scheduleHabitReminder(
            result.updatedHabit.id,
            result.updatedHabit.name,
            result.updatedHabit.reminderTime!,
            createdAt: result.updatedHabit.createdAt,
          );
        }
      }

      _updateHomeWidget();
      notifyListeners();
    } catch (e) {
      debugPrint("HabitX Completion Toggle Error: $e");
    }
  }

  void setAiTimer(int minutes) {
    _currentSeconds = minutes * 60;
    _resumeCountdown();
    notifyListeners();
  }

  void triggerXpReport() {
    HapticHelper.success();
    notifyListeners();
  }

  void addBonusXp(int xp) {
    _applyGamification(xp);
    notifyListeners();
  }

  void _updateHomeWidget() {
    final now = DateTime.now();
    final todayHabits = _allHabits.where((habit) {
      return habit.createdAt.isBefore(
        DateTime(now.year, now.month, now.day, 23, 59, 59),
      );
    }).toList();

    final int maxStreak = _allHabits.isEmpty
        ? 0
        : _allHabits.map((h) => h.streak).reduce((a, b) => a > b ? a : b);
    final int completedCount = todayHabits.where((h) => h.isCompleted).length;
    final int totalCount = todayHabits.length;

    HomeWidgetService.updateWidget(
      streak: maxStreak,
      level: _userLevel,
      completedCount: completedCount,
      totalCount: totalCount,
      habits: todayHabits,
    );
  }

  // --- Gamification Engine ---

  void _applyGamification(int xp) {
    _userXP += xp;
    final newLevel = XpLevelCalculator.calculateNewLevel(_userXP, _userLevel);
    if (newLevel > _userLevel) {
      for (int l = _userLevel + 1; l <= newLevel; l++) {
        if (_isHapticsEnabled) HapticHelper.levelUp();
        if (navigatorKey.currentContext != null) {
          LevelUpOverlay.show(navigatorKey.currentContext!, l);
        }
      }
      _userLevel = newLevel;
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

  // --- Streak Freeze Engine ---

  void _checkAndReplenishFreezes() {
    final now = DateTime.now();
    bool needsSave = false;
    for (int i = 0; i < _allHabits.length; i++) {
      final habit = _allHabits[i];
      if (StreakEngine.needsFreezeReplenish(habit.lastFreezeResetDate, now)) {
        _allHabits[i] = habit.copyWith(
          streakFreezesAvailable: 1,
          lastFreezeResetDate: now,
        );
        needsSave = true;
      }
    }
    if (needsSave) {
      _storage.saveHabits(_allHabits);
    }
  }

  bool canFreezeHabit(Habit habit) {
    return StreakEngine.canFreezeHabit(habit);
  }

  void useStreakFreeze(BuildContext? context, String habitId) {
    final index = _allHabits.indexWhere((h) => h.id == habitId);
    if (index == -1) return;

    final habit = _allHabits[index];
    if (!canFreezeHabit(habit)) return;

    final now = DateTime.now();
    final updatedFrozenDates = List<DateTime>.from(habit.frozenDates)..add(now);

    _allHabits[index] = habit.copyWith(
      streakFreezesAvailable: habit.streakFreezesAvailable - 1,
      frozenDates: updatedFrozenDates,
    );

    _storage.saveHabits(_allHabits);
    _updateHomeWidget();
    notifyListeners();
  }

  // --- Habit Stacking / Circular Validation ---

  bool isCircularChain(String startId, String? triggerId) {
    return HabitStackingValidator.isCircularChain(
      startId: startId,
      triggerId: triggerId,
      allHabits: _allHabits,
    );
  }

  // --- Contextual Nudge Overlay ---

  void _showStackedNudge(BuildContext context, Habit stackedHabit) {
    AchievementOverlayHelper.showStackedNudge(
      context: context,
      stackedHabit: stackedHabit,
      onComplete: () => toggleHabitCompletion(context, stackedHabit.id),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      debugPrint("HabitX Neural Resume: Re-syncing state from disk...");
      init();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }
}
