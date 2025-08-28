import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_task_ksekwo/steps/pain_choice_step.dart';
import 'package:flutter_task_ksekwo/constants/colors.dart';

void main() {
  group('PainChoiceStep Widget Tests', () {
    testWidgets('should display description and choices', (WidgetTester tester) async {
      final testChoices = [
        {'text': 'Choice 1', 'value': 1},
        {'text': 'Choice 2', 'value': 2},
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: PainChoiceStep(
            description: 'Test Description',
            choices: testChoices,
            onNext: () {},
          ),
        ),
      );

      expect(find.text('Test Description'), findsOneWidget);
      expect(find.text('Choice 1'), findsOneWidget);
      expect(find.text('Choice 2'), findsOneWidget);
      expect(find.text('Select one of the options:'), findsOneWidget);
    });

    testWidgets('should enable continue button after selection', (WidgetTester tester) async {
      final testChoices = [
        {'text': 'Choice 1', 'value': 1},
        {'text': 'Choice 2', 'value': 2},
      ];
      bool nextCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: PainChoiceStep(
            description: 'Test Description',
            choices: testChoices,
            onNext: () { nextCalled = true; },
          ),
        ),
      );

      final continueButton = find.text('CONTINUE');
      expect(continueButton, findsOneWidget);

      await tester.tap(find.text('Choice 1'));
      await tester.pump();

      await tester.tap(continueButton);
      await tester.pump();

      expect(nextCalled, isTrue);
    });

    testWidgets('should show selected choice indicator', (WidgetTester tester) async {
      final testChoices = [
        {'text': 'Choice 1', 'value': 1},
        {'text': 'Choice 2', 'value': 2},
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: PainChoiceStep(
            description: 'Test Description',
            choices: testChoices,
            onNext: () {},
          ),
        ),
      );

      await tester.tap(find.text('Choice 1'));
      await tester.pump();

      expect(find.textContaining('Selected:'), findsOneWidget);
      expect(find.text('Choice 1'), findsOneWidget);
    });
  });
}
