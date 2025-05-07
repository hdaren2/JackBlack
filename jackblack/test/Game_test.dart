import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jackblack/game.dart';
import 'package:jackblack/card.dart';
import 'package:jackblack/hand.dart';
import 'package:jackblack/player.dart';

void main() {
  group('Edge Cases', () {
    late GamePage gamePage;

    setUp(() {
      gamePage = const GamePage();
    });

    testWidgets('Multiple Aces in hand', (WidgetTester tester) async {
      // Create a test widget
      final testWidget = MaterialApp(home: gamePage);

      // Pump the widget into the widget tree
      await tester.pumpWidget(testWidget);

      // Add your test logic here using the public interface
    });

    testWidgets('Hit customButton test', (WidgetTester tester) async {
      final testkey1 = Key("Hit_custom");
      bool buttonPressed = false;
      await tester.pumpWidget(
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Wrap(
              spacing: 15,
              runSpacing: 15,
              alignment: WrapAlignment.center,
              children: [CustomButton(text: "Hit", onPressed: () {})],
            ),
          ],
        ),
      );
      // Verify the label is displayed
      expect(find.text('Hit'), findsOneWidget);

      // Tap the button and verify the onPressed callback is triggered
      await tester.tap(find.byKey(testkey1));
      await tester.pump(); // Rebuild the widget

      expect(buttonPressed, isTrue);
    });
  });
  //end of test case
}
