import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lissan_ai/features/practice_speaking/presentation/widgets/navigation_buttons.dart';

void main() {
  group('NavigationButtons Tests', () {
    testWidgets('Previous button is hidden when currentPage == 1',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NavigationButtons(
              currentPage: 1,
              maxPage: 5,
              onPrevious: () {},
              onNext: () {},
              status: false,
            ),
          ),
        ),
      );

      expect(find.text('Previous'), findsNothing);
    });

    testWidgets('Previous button is visible and clickable when currentPage > 1',
        (WidgetTester tester) async {
      bool previousCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NavigationButtons(
              currentPage: 2,
              maxPage: 5,
              onPrevious: () => previousCalled = true,
              onNext: () {},
              status: false,
            ),
          ),
        ),
      );

      expect(find.text('Previous'), findsOneWidget);

      await tester.tap(find.text('Previous'));
      await tester.pump();

      expect(previousCalled, isTrue);
    });

    testWidgets('Shows "Next Question" when not on last page',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NavigationButtons(
              currentPage: 2,
              maxPage: 5,
              onPrevious: () {},
              onNext: () {},
              status: false,
            ),
          ),
        ),
      );

      expect(find.text('Next Question'), findsOneWidget);
      expect(find.text('End Session'), findsNothing);
    });

    testWidgets('Shows "End Session" on last page',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NavigationButtons(
              currentPage: 5,
              maxPage: 5,
              onPrevious: () {},
              onNext: () {},
              status: false,
            ),
          ),
        ),
      );

      expect(find.text('End Session'), findsOneWidget);
    });

    testWidgets('onNext is called when status is false',
        (WidgetTester tester) async {
      bool nextCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NavigationButtons(
              currentPage: 1,
              maxPage: 5,
              onPrevious: () {},
              onNext: () => nextCalled = true,
              status: false,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Next Question'));
      await tester.pump();

      expect(nextCalled, isTrue);
    });

    testWidgets('Next button shows loader and is disabled when status is true',
        (WidgetTester tester) async {
      bool nextCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NavigationButtons(
              currentPage: 1,
              maxPage: 5,
              onPrevious: () {},
              onNext: () => nextCalled = true,
              status: true,
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.tap(find.byType(ElevatedButton).last);
      await tester.pump();

      expect(nextCalled, isFalse); // should not be triggered
    });
  });
}
