import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_task_ksekwo/steps/wheel_step.dart';

void main() {
  group('WheelStep Widget Tests', () {
    testWidgets('should display pain scale with numbers 0-10', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WheelStep(
            buttonText: 'Rate your pain',
            onNext: () {},
          ),
        ),
      );

      expect(find.text('Rate your pain'), findsOneWidget);
      expect(find.text('Select a number from 0 to 10:'), findsOneWidget);
      expect(find.text('Pain Scale'), findsOneWidget);
      expect(find.text('Select a number'), findsOneWidget);
      
      for (int i = 0; i <= 10; i++) {
        expect(find.text(i.toString()), findsOneWidget);
      }
    });

    testWidgets('should update center display when number selected', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WheelStep(
            buttonText: 'Rate your pain',
            onNext: () {},
          ),
        ),
      );

      await tester.tap(find.text('5').first);
      await tester.pump();

      expect(find.text('Pain Scale'), findsNothing);
      expect(find.text('5'), findsNWidgets(2));
      expect(find.text('Poziom bólu'), findsOneWidget);
    });

    testWidgets('should enable continue button after selection', (WidgetTester tester) async {
      bool nextCalled = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: WheelStep(
            buttonText: 'Rate your pain',
            onNext: () { nextCalled = true; },
          ),
        ),
      );

      await tester.tap(find.text('7').first);
      await tester.pump();

      await tester.tap(find.text('NEXT'));
      await tester.pump();

      expect(nextCalled, isTrue);
    });

    testWidgets('should show selected value summary', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WheelStep(
            buttonText: 'Rate your pain',
            onNext: () {},
          ),
        ),
      );

      await tester.tap(find.text('8').first);
      await tester.pump();

      expect(find.textContaining('Selected value: 8'), findsOneWidget);
    });
  });
}
