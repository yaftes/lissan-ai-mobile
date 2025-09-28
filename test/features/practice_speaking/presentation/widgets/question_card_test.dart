import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lissan_ai/features/practice_speaking/presentation/widgets/question_card.dart';

void main() {
  group('QuestionCard Widget Tests', () {
    testWidgets('renders question text when status is false', (WidgetTester tester) async {
      const question = 'What is Flutter?';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuestionCard(
              question: question,
              onSpeak: () {},
              status: false,
            ),
          ),
        ),
      );

      // Question text should appear
      expect(find.text(question), findsOneWidget);

      // LinearProgressIndicator should not be shown
      expect(find.byType(LinearProgressIndicator), findsNothing);
    });

    testWidgets('shows loading indicator when status is true', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuestionCard(
              question: 'Ignored when loading',
              onSpeak: () {},
              status: true,
            ),
          ),
        ),
      );

      // LinearProgressIndicator should appear
      expect(find.byType(LinearProgressIndicator), findsOneWidget);

      // Question text should NOT appear
      expect(find.text('Ignored when loading'), findsNothing);
    });

    testWidgets('displays tags and XP badge', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuestionCard(
              question: 'Sample Q',
              onSpeak: () {},
              status: false,
            ),
          ),
        ),
      );

      expect(find.text('General'), findsOneWidget);
      expect(find.text('Easy'), findsOneWidget);
      expect(find.text('50XP'), findsOneWidget);
    });

    testWidgets('calls onSpeak when volume button is tapped', (WidgetTester tester) async {
      bool wasPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuestionCard(
              question: 'Speak test',
              onSpeak: () {
                wasPressed = true;
              },
              status: false,
            ),
          ),
        ),
      );

      // Tap the IconButton
      await tester.tap(find.byIcon(Icons.volume_up));
      await tester.pump();

      expect(wasPressed, isTrue);
    });

    testWidgets('displays Lissan tip text', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuestionCard(
              question: 'Tip test',
              onSpeak: () {},
              status: false,
            ),
          ),
        ),
      );

      expect(
        find.textContaining("Lissan's Tip"),
        findsOneWidget,
      );
    });
  });
}
