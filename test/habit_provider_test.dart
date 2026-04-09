import 'package:flutter_test/flutter_test.dart';
// Matches the 'name: habitx' in your pubspec.yaml
import 'package:habitx/providers/habit_provider.dart';
import 'package:habitx/domain/models/habit.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('HabitX Logic: Deleting a habit should reduce list length', () {
    final provider = HabitProvider();

    final habit = Habit(
      id: '1',
      name: 'Test Mission',
      difficulty: HabitDifficulty.easy,
      timerDuration: 10,
      createdAt: DateTime.now(),
      lastCompleted: DateTime.now(),
      isCompleted: false,
      streak: 0,
    );

    provider.addHabit(habit);
    expect(provider.allHabits.length, 1);

    provider.deleteHabit('1');
    expect(provider.allHabits.length, 0);
  });
}
