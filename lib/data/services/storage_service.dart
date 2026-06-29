import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/habit.dart';

class StorageService {
  // Key constants for local disk access
  static const String _habitsKey = 'user_habits';
  static const String _xpKey = 'user_xp';
  static const String _levelKey = 'user_level';
  static const String _nameKey = 'user_name';
  static const String _ageKey = 'user_age'; // NEW
  static const String _personaKey = 'user_persona'; // NEW
  static const String _isNewUserKey = 'is_new_user';
  static const String _achievementsKey = 'unlocked_achievements'; // NEW
  static const String _hapticsKey = 'haptics_enabled'; // NEW
  static const String _dailyMotivationKey = 'daily_motivation_enabled';

  // --- 1. User Identity & Onboarding ---

  Future<void> saveUserIdentity({
    required String name,
    required int age,
    required String persona,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nameKey, name);
    await prefs.setInt(_ageKey, age);
    await prefs.setString(_personaKey, persona);
    await prefs.setBool(_isNewUserKey, false);
  }

  Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_nameKey);
  }

  Future<int?> getUserAge() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_ageKey);
  }

  Future<String?> getUserPersona() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_personaKey);
  }

  Future<bool> isNewUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isNewUserKey) ?? true;
  }

  // --- 2. Achievement Persistence ---

  /// NEW: Saves the list of unlocked badge IDs to disk
  Future<void> saveUnlockedAchievements(List<String> achievementIds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_achievementsKey, achievementIds);
  }

  /// NEW: Loads the list of unlocked badge IDs
  Future<List<String>> loadUnlockedAchievements() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_achievementsKey) ?? [];
  }

  // --- 3. Habit Persistence (Complex JSON) ---

  Future<void> saveHabits(List<Habit> habits) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String encodedData = jsonEncode(
        habits.map((h) => h.toMap()).toList(),
      );
      await prefs.setString(_habitsKey, encodedData);
    } catch (e) {
      // Internal logging for Shalcontech Studio stability
    }
  }

  Future<List<Habit>> loadHabits() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? habitData = prefs.getString(_habitsKey);

      if (habitData == null || habitData.isEmpty) return [];

      final List<dynamic> decodedData = jsonDecode(habitData);
      return decodedData.map((item) => Habit.fromMap(item)).toList();
    } catch (e) {
      return [];
    }
  }

  // --- 4. Gamification & System Progress ---

  Future<void> saveProgress(int xp, int level) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_xpKey, xp);
    await prefs.setInt(_levelKey, level);
  }

  Future<Map<String, int>> loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'xp': prefs.getInt(_xpKey) ?? 0,
      'level': prefs.getInt(_levelKey) ?? 1,
    };
  }

  /// NEW: Persists the user's vibration/haptic preferences
  Future<void> saveHapticPreference(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hapticsKey, enabled);
  }

  /// NEW: Loads haptic preference (Defaults to true)
  Future<bool> loadHapticPreference() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_hapticsKey) ?? true;
  }

  /// Persists daily motivation preference (Defaults to true)
  Future<void> saveDailyMotivationPreference(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_dailyMotivationKey, enabled);
  }

  Future<bool> loadDailyMotivationPreference() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_dailyMotivationKey) ?? true;
  }

  // --- 5. System Actions ---

  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
