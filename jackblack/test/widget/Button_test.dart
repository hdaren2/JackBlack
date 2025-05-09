import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jackblack/game.dart';
import 'package:jackblack/main(2).dart';
import 'package:jackblack/widgets/custom_button.dart';

//testing button UI for functionality. For simplicity I did not test it in the context of the game logic, just that they work.
void main() {
  group('Button fuctionality Tests', () { //grouping widgets together for testing

// testing the hit button UI
  testWidgets('Hit customButton test', (WidgetTester tester) async {
    final testkey1 = Key("Hit_custom");
    bool buttonPressed = false;
    
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Wrap(
                spacing: 15,
                runSpacing: 15,
                alignment: WrapAlignment.center,
                children: [
                  CustomButton(
                    key: testkey1,
                    text: "Hit",
                    onPressed: () {
                      buttonPressed = true;
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    // Verify the label is displayed
    expect(find.text('Hit'), findsOneWidget);

    // Tap the button and verify the onPressed callback is triggered
    await tester.tap(find.byKey(testkey1));
    await tester.pump(); // Rebuild the widget

    expect(buttonPressed, isTrue);
  });


//testing the stand button UI
   testWidgets('Stand customButton test', (WidgetTester tester) async {
    final testkey2 = Key("Stand_custom");
    bool buttonPressed = false;
    
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Wrap(
                spacing: 15,
                runSpacing: 15,
                alignment: WrapAlignment.center,
                children: [
                  CustomButton(
                    key: testkey2,
                    text: "Stand",
                    onPressed: () {
                      buttonPressed = true;
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    // Verify the label is displayed
    expect(find.text('Stand'), findsOneWidget);

    // Tap the button and verify the onPressed callback is triggered
    await tester.tap(find.byKey(testkey2));
    await tester.pump(); 

    expect(buttonPressed, isTrue);
    });

//testing the double down button UI
    testWidgets('Double Down customButton test', (WidgetTester tester) async {
    final testkey3 = Key("double_custom");
    bool buttonPressed = false;
    
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Wrap(
                spacing: 15,
                runSpacing: 15,
                alignment: WrapAlignment.center,
                children: [
                  CustomButton(
                    key: testkey3,
                    text: "Double Down",
                    onPressed: () {
                      buttonPressed = true;
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    // Verify the label is displayed
    expect(find.text('Double Down'), findsOneWidget);

    // Tap the button and verify the onPressed callback is triggered
    await tester.tap(find.byKey(testkey3));
    await tester.pump(); 

    expect(buttonPressed, isTrue);
    });

//testing the insurance button UI
    testWidgets('Insurance customButton test', (WidgetTester tester) async {
    final testkey4 = Key("Insurance_custom");
    bool buttonPressed = false;
    
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Wrap(
                spacing: 15,
                runSpacing: 15,
                alignment: WrapAlignment.center,
                children: [
                  CustomButton(
                    key: testkey4,
                    text: "Insurance",
                    onPressed: () {
                      buttonPressed = true;
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    // Verify the label is displayed
    expect(find.text('Insurance'), findsOneWidget);

    // Tap the button and verify the onPressed callback is triggered
    await tester.tap(find.byKey(testkey4));
    await tester.pump(); 

    expect(buttonPressed, isTrue);
    });

//testing the split button UI
    testWidgets('Split customButton test', (WidgetTester tester) async {
    final testkey5 = Key("Split_custom");
    bool buttonPressed = false;
    
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Wrap(
                spacing: 15,
                runSpacing: 15,
                alignment: WrapAlignment.center,
                children: [
                  CustomButton(
                    key: testkey5,
                    text: "Split",
                    onPressed: () {
                      buttonPressed = true;
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    // Verify the label is displayed
    expect(find.text('Split'), findsOneWidget);

    // Tap the button and verify the onPressed callback is triggered
    await tester.tap(find.byKey(testkey5));
    await tester.pump(); 

    expect(buttonPressed, isTrue);
    });

//testing the surrender button UI
    testWidgets('Surrender customButton test', (WidgetTester tester) async {
    final testkey6 = Key("Surrender_custom");
    bool buttonPressed = false;
    
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Wrap(
                spacing: 15,
                runSpacing: 15,
                alignment: WrapAlignment.center,
                children: [
                  CustomButton(
                    key: testkey6,
                    text: "Surrender",
                    onPressed: () {
                      buttonPressed = true;
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    // Verify the label is displayed
    expect(find.text('Surrender'), findsOneWidget);

    // Tap the button and verify the onPressed callback is triggered
    await tester.tap(find.byKey(testkey6));
    await tester.pump(); 

    expect(buttonPressed, isTrue);
    });

//testing the quit game button UI
    testWidgets('Quit Game customButton test', (WidgetTester tester) async {
    final testkey7 = Key("Quit Game_custom");
    bool buttonPressed = false;
    
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Wrap(
                spacing: 15,
                runSpacing: 15,
                alignment: WrapAlignment.center,
                children: [
                  CustomButton(
                    key: testkey7,
                    text: "Quit Game",
                    onPressed: () {
                      buttonPressed = true;
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    // Verify the label is displayed
    expect(find.text('Quit Game'), findsOneWidget);

    // Tap the button and verify the onPressed callback is triggered
    await tester.tap(find.byKey(testkey7));
    await tester.pump(); 

    expect(buttonPressed, isTrue);
    });
  });}