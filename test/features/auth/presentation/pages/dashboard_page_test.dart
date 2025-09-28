import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lissan_ai/features/auth/presentation/pages/dashboard_page.dart';

void main() {
  testWidgets('Dashboard shows greeting text and sections',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Dashboard(),
      ),
    );

    expect(find.textContaining('Good'), findsOneWidget);

    expect(find.text('Your Progress'), findsOneWidget);

    expect(find.text('Practice Lessons'), findsOneWidget);

    expect(find.text('Pronunciation Coach'), findsOneWidget);
  });
}
