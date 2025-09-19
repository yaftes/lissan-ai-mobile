import 'package:flutter/material.dart';
import 'package:flutter/src/services/platform_channel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lissan_ai/features/practice_speaking/domain/entities/interview_question.dart';
import 'package:lissan_ai/features/practice_speaking/presentation/bloc/practice_speaking_bloc.dart';
import 'package:lissan_ai/features/practice_speaking/presentation/pages/mock_interview_page.dart';
import 'package:lissan_ai/features/practice_speaking/presentation/widgets/navigation_buttons.dart';
import 'package:lissan_ai/features/practice_speaking/presentation/widgets/question_card.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shimmer/shimmer.dart';
import 'package:bloc_test/bloc_test.dart';

// Mock and Fake classes from step 2
class MockPracticeSpeakingBloc extends MockBloc<PracticeSpeakingEvent, PracticeSpeakingState> 
  implements PracticeSpeakingBloc {}

class FakePracticeSpeakingState extends Fake implements PracticeSpeakingState {}
class FakePracticeSpeakingEvent extends Fake implements PracticeSpeakingEvent {}


void main() {
  late MockPracticeSpeakingBloc mockBloc;

  setUpAll(() {
    // Register fallbacks for mocktail
    registerFallbackValue(FakePracticeSpeakingState());
    registerFallbackValue(FakePracticeSpeakingEvent());
  });

  setUp(() {
    mockBloc = MockPracticeSpeakingBloc();
  });

  // A helper function to wrap the widget in necessary providers
  Widget _buildTestableWidget(Widget child) {
    return BlocProvider<PracticeSpeakingBloc>.value(
      value: mockBloc,
      child: MaterialApp(
        home: child,
      ),
    );
  }

  group('MockInterviewPage', () {
    testWidgets('adds StartPracticeSessionEvent on initState', (tester) async {
      // Arrange: Stub the BLoC to have an initial state
      when(() => mockBloc.state).thenReturn(const PracticeSpeakingState());

      // Act: Pump the widget
      await tester.pumpWidget(_buildTestableWidget(const MockInterviewPage()));

      // Assert: Verify that the event was added. This happens in initState.
      // Note: We ignore the TTS platform channel errors which are expected in tests.
      final logs = <String>[];
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        any as MethodChannel,
        (methodCall) async {
          logs.add(methodCall.method);
          return null;
        },
      );

      verify(() => mockBloc.add(const StartPracticeSessionEvent(type: 'interview'))).called(1);
    });

    testWidgets('displays Shimmer when status is loading', (tester) async {
      // Arrange: Stub the BLoC to return a loading state
      when(() => mockBloc.state).thenReturn(const PracticeSpeakingState(status: BlocStatus.loading));

      // Act
      await tester.pumpWidget(_buildTestableWidget(const MockInterviewPage()));

      // Assert
      expect(find.byType(Shimmer), findsOneWidget);
      expect(find.byType(QuestionCard), findsNothing);
    });

    testWidgets('displays QuestionCard when questions are loaded', (tester) async {
      // Arrange
      final question = InterviewQuestion(question: 'Tell me about a challenge you faced.');
      when(() => mockBloc.state).thenReturn(
        PracticeSpeakingState(
          status: BlocStatus.questionsLoaded,
          currentQuestion: question,
        ),
      );

      // Act
      await tester.pumpWidget(_buildTestableWidget(const MockInterviewPage()));

      // Assert
      expect(find.byType(QuestionCard), findsOneWidget);
      expect(find.text(question.question), findsOneWidget);
      expect(find.byType(NavigationButtons), findsOneWidget);
      expect(find.byType(Shimmer), findsNothing);
    });

    testWidgets('displays error message when status is error', (tester) async {
      // Arrange
      when(() => mockBloc.state).thenReturn(
        const PracticeSpeakingState(status: BlocStatus.error, error: 'Network Failure'),
      );

      // Act
      await tester.pumpWidget(_buildTestableWidget(const MockInterviewPage()));

      // Assert
      expect(find.text('Network Failure'), findsOneWidget);
      expect(find.byType(Shimmer), findsNothing);
    });

    testWidgets('tapping next button adds GetInterviewQuestionsEvent when more questions are needed', (tester) async {
      // Arrange
      final question = InterviewQuestion(question: 'First question');
      when(() => mockBloc.state).thenReturn(
        PracticeSpeakingState(
          status: BlocStatus.questionsLoaded,
          currentQuestion: question,
          questions: [question], // Only one question loaded so far
          currentQuestionIndex: 0,
        ),
      );

      await tester.pumpWidget(_buildTestableWidget(const MockInterviewPage()));

      // Act
      // Find the 'Next' button inside NavigationButtons and tap it
      final nextButton = find.descendant(
        of: find.byType(NavigationButtons),
        matching: find.byIcon(Icons.arrow_forward),
      );
      await tester.tap(nextButton);
      await tester.pump();

      // Assert: Verify the correct event was added to fetch the next question.
      verify(() => mockBloc.add(const GetInterviewQuestionsEvent())).called(1);
    });
  });
}