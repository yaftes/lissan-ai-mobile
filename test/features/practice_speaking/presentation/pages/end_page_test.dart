import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lissan_ai/features/practice_speaking/data/models/practice_session_result_model.dart';
import 'package:lissan_ai/features/practice_speaking/presentation/pages/end_page.dart';
import 'package:lissan_ai/features/practice_speaking/presentation/pages/mock_interview_page.dart';

void main() {
  group('EndPage Widget Tests', () {
    // Create a mock PracticeSessionResultModel
    final mockFeedback = PracticeSessionResultModel(
      finalScore: 85,
      completed: 3,
      totalQuestions: 5,
      strengths: ['Good pronunciation', 'Fluent speaking'],
      weaknesses: ['Needs better grammar'], sessionId: '', createdAt: 1234,
    );

    testWidgets('renders title and feedback details', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: EndPage(feedback: mockFeedback, currentPage: 1),
        ),
      );

      // Check title
      expect(find.text('Practice Session Ended'), findsOneWidget);

      // Check feedback values
      expect(find.text('Final Score: 85%'), findsOneWidget);
      expect(find.text('Completed: 3/5'), findsOneWidget);
    });

    testWidgets('renders strengths and weaknesses when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: EndPage(feedback: mockFeedback, currentPage: 1),
        ),
      );

      // Strengths
      expect(find.textContaining('✅ Good pronunciation'), findsOneWidget);
      expect(find.textContaining('✅ Fluent speaking'), findsOneWidget);

      // Weaknesses
      expect(find.textContaining('⚠️ Needs better grammar'), findsOneWidget);
    });

    testWidgets('navigates to MockInterviewPage on Retake Session button tap', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: EndPage(feedback: mockFeedback, currentPage: 1),
        ),
      );

      // Find and tap the button
      final buttonFinder = find.text('Retake Session');
      expect(buttonFinder, findsOneWidget);
      await tester.tap(buttonFinder);
      await tester.pumpAndSettle();

      // Verify navigation to MockInterviewPage
      expect(find.byType(MockInterviewPage), findsOneWidget);
    });
  });
}
