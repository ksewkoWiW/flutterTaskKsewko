import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_task_ksekwo/main.dart';

void main() {
  group('Wizard Integration Tests', () {
    testWidgets('should complete full wizard flow', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      expect(find.text('OPEN THE FORM'), findsOneWidget);
      
      await tester.tap(find.text('OPEN THE FORM'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byType(Scaffold), findsNWidgets(2));
    });

    testWidgets('should show progress through steps', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      
      await tester.tap(find.text('OPEN THE FORM'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      
      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}
