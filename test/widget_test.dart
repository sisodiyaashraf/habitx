import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitx/presentation/widgets/tracking/progress_item_tile.dart';

void main() {
  testWidgets('ProgressItemTile Widget Rendering Test', (WidgetTester tester) async {
    const titleText = 'Drink Water';
    const progressText = '2 of 8 cups';
    const iconData = Icons.local_drink;

    // Build the widget in a test MaterialApp environment
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ProgressItemTile(
            title: titleText,
            progress: progressText,
            icon: iconData,
          ),
        ),
      ),
    );

    // Verify that the title and progress text are printed
    expect(find.text(titleText), findsOneWidget);
    expect(find.text(progressText), findsOneWidget);

    // Verify the presence of the icon
    expect(find.byIcon(iconData), findsOneWidget);
  });
}
