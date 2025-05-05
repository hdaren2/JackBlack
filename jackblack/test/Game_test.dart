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
  });
}
