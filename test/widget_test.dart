// Flutter widget tests for the main application
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_task_ksekwo/main.dart';

void main() {
  group('Main App Tests', () {
    testWidgets('should show main page with open form button', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      expect(find.text('Flutter Task App'), findsOneWidget);
      expect(find.text('OPEN THE FORM'), findsOneWidget);
      
      final button = find.text('OPEN THE FORM');
      await tester.tap(button);
      await tester.pumpAndSettle();
      
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('should have correct app title', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      
      final MaterialApp app = tester.widget(find.byType(MaterialApp));
      expect(app.title, 'Flutter Task Ksewko');
    });

    testWidgets('should display app bar with styled title', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Flutter Task App'), findsOneWidget);
    });
  });
}
