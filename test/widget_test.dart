import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitx/domain/models/habit.dart';
import 'package:habitx/presentation/widgets/tracking/progress_item_tile.dart';

void main() {
  testWidgets('ProgressItemTile Widget Rendering Test', (WidgetTester tester) async {
    final testHabit = Habit(
      id: 'test_id',
      name: 'Drink Water',
      isCompleted: false,
      streak: 2,
      difficulty: HabitDifficulty.easy,
      lastCompleted: DateTime.now().subtract(const Duration(days: 1)),
    );

    // Build the widget in a test MaterialApp environment
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ProgressItemTile(
            habit: testHabit,
          ),
        ),
      ),
    );

    // Verify that the title and streak text are printed
    expect(find.text('Drink Water'), findsOneWidget);
    expect(find.text('2 DAY STREAK'), findsOneWidget);

    // Verify the presence of the standby unchecked icon
    expect(find.byIcon(Icons.radio_button_unchecked), findsOneWidget);
  });
}
