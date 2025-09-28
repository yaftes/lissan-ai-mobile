import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lissan_ai/core/error/failure.dart';
import 'package:lissan_ai/features/practice_speaking/domain/entities/answer_feed_back.dart';
import 'package:lissan_ai/features/practice_speaking/domain/entities/interview_question.dart';
import 'package:lissan_ai/features/practice_speaking/domain/entities/practice_session_result.dart';
import 'package:lissan_ai/features/practice_speaking/domain/entities/practice_session_start.dart';
import 'package:lissan_ai/features/practice_speaking/domain/usecases/end_pracice_session_usecase.dart';
import 'package:lissan_ai/features/practice_speaking/domain/usecases/get_interview_questions_usecase.dart';
import 'package:lissan_ai/features/practice_speaking/domain/usecases/recognize_speech.dart';
import 'package:lissan_ai/features/practice_speaking/domain/usecases/start_practice_session_usecase.dart';
import 'package:lissan_ai/features/practice_speaking/domain/usecases/submit_answer_and_get_feedback_usecase.dart';
import 'package:lissan_ai/features/practice_speaking/presentation/bloc/practice_speaking_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'dart:async';

// ---------------- Mock Classes ----------------
class MockStartPracticeSessionUsecase extends Mock
    implements StartPracticeSessionUsecase {}

class MockEndPracticeSessionUsecase extends Mock
    implements EndPraciceSessionUsecase {}

class MockGetInterviewQuestionsUsecase extends Mock
    implements GetInterviewQuestionsUsecase {}

class MockSubmitAnswerUsecase extends Mock
    implements SubmitAnswerAndGetFeedbackUsecase {}

class MockRecognizeSpeechUsecase extends Mock implements RecognizeSpeechUsecase {}

void main() {
  late MockStartPracticeSessionUsecase mockStart;
  late MockEndPracticeSessionUsecase mockEnd;
  late MockGetInterviewQuestionsUsecase mockGetQuestions;
  late MockSubmitAnswerUsecase mockSubmit;
  late MockRecognizeSpeechUsecase mockSpeech;
  late PracticeSpeakingBloc bloc;

  setUp(() {
    mockStart = MockStartPracticeSessionUsecase();
    mockEnd = MockEndPracticeSessionUsecase();
    mockGetQuestions = MockGetInterviewQuestionsUsecase();
    mockSubmit = MockSubmitAnswerUsecase();
    mockSpeech = MockRecognizeSpeechUsecase();

    // Default stubs for speech streams
    when(() => mockSpeech.recognizedWords).thenAnswer((_) => const Stream.empty());
    when(() => mockSpeech.errors).thenAnswer((_) => const Stream.empty());

    bloc = PracticeSpeakingBloc(
      startPracticeSessionUsecase: mockStart,
      endPracticeSessionUsecase: mockEnd,
      getInterviewQuestionsUsecase: mockGetQuestions,
      submitAndGetAnswerUsecase: mockSubmit,
      recognizeSpeech: mockSpeech,
    );
  });

  tearDown(() {
    bloc.close();
  });

  // ---------------- Tests ----------------

  group('StartPracticeSessionEvent', () {
    const tType = 'interview';
    final session = PracticeSessionStart(sessionId: '123', questionNumber: 1);

    blocTest<PracticeSpeakingBloc, PracticeSpeakingState>(
      'emits [loading, sessionStarted] when successful',
      build: () {
        when(() => mockStart(tType)).thenAnswer((_) async => Right(session));
        return bloc;
      },
      act: (bloc) => bloc.add(const StartPracticeSessionEvent(type: tType)),
      expect: () => [
        const PracticeSpeakingState(status: BlocStatus.loading),
        PracticeSpeakingState(status: BlocStatus.sessionStarted, session: session),
      ],
    );

    blocTest<PracticeSpeakingBloc, PracticeSpeakingState>(
      'emits [loading, error] when failure',
      build: () {
        when(() => mockStart(tType))
            .thenAnswer((_) async => const Left(ServerFailure(message: 'error')));
        return bloc;
      },
      act: (bloc) => bloc.add(const StartPracticeSessionEvent(type: tType)),
      expect: () => [
        const PracticeSpeakingState(status: BlocStatus.loading),
        const PracticeSpeakingState(status: BlocStatus.error, error: 'ServerFailure(message: error)'),
      ],
    );
  });

  group('EndPracticeSessionEvent', () {
    const tSessionId = '123';
    final result = PracticeSessionResult(
      sessionId: '123',
      totalQuestions: 5,
      completed: 5,
      strengths: [],
      weaknesses: [],
      finalScore: 90,
      createdAt: 123,
    );

    blocTest<PracticeSpeakingBloc, PracticeSpeakingState>(
      'emits [loading, sessionEnded]',
      build: () {
        when(() => mockEnd(tSessionId)).thenAnswer((_) async => Right(result));
        return bloc;
      },
      act: (bloc) => bloc.add(const EndPracticeSessionEvent(sessionId: tSessionId)),
      expect: () => [
        const PracticeSpeakingState(status: BlocStatus.loading),
        PracticeSpeakingState(status: BlocStatus.sessionEnded, endSessionFeedback: result),
      ],
    );
  });

  group('GetInterviewQuestionsEvent', () {
    const tSessionId = '123';
    final tQuestion = InterviewQuestion(question: 'Tell me about yourself');
    final session = PracticeSessionStart(sessionId: '123', questionNumber: 1);

    blocTest<PracticeSpeakingBloc, PracticeSpeakingState>(
      'emits [questionLoading, questionsLoaded]',
      build: () {
        when(() => mockGetQuestions(tSessionId)).thenAnswer((_) async => Right(tQuestion));
        return bloc;
      },
      seed: () => PracticeSpeakingState(session: session),
      act: (bloc) => bloc.add(const GetInterviewQuestionsEvent()),
      expect: () => [
        PracticeSpeakingState(session: session, status: BlocStatus.questionLoading),
        PracticeSpeakingState(
          session: session,
          status: BlocStatus.questionsLoaded,
          currentQuestion: tQuestion,
          questions: [tQuestion],
          currentQuestionIndex: 0,
        ),
      ],
    );
  });

  group('SubmitAnswerEvent', () {
    final session = PracticeSessionStart(sessionId: '123', questionNumber: 1);
    final feedback = AnswerFeedback(
      overallSummary: 'Good',
      feedbackPoints: [],
      scorePercentage: 90,
    );

    blocTest<PracticeSpeakingBloc, PracticeSpeakingState>(
      'emits [loading, feedbackReceived]',
      build: () {
        when(() => mockSubmit(any())).thenAnswer((_) async => Right(feedback));
        return bloc;
      },
      seed: () => PracticeSpeakingState(session: session),
      act: (bloc) => bloc.add(const SubmitAnswerEvent(answer: 'My answer')),
      expect: () => [
        PracticeSpeakingState(session: session, status: BlocStatus.loading),
        PracticeSpeakingState(
          session: session,
          status: BlocStatus.feedbackReceived,
          feedback: feedback,
        ),
      ],
    );
  });

  group('Speech events', () {
    blocTest<PracticeSpeakingBloc, PracticeSpeakingState>(
      'InitSpeechEvent subscribes to streams',
      build: () {
        when(() => mockSpeech.init()).thenAnswer((_) async {});
        return bloc;
      },
      act: (bloc) => bloc.add(InitSpeechEvent()),
      verify: (_) {
        verify(() => mockSpeech.init()).called(1);
      },
    );

    blocTest<PracticeSpeakingBloc, PracticeSpeakingState>(
      'StartListeningEvent emits isListening=true',
      build: () {
        when(() => mockSpeech.startListening()).thenAnswer((_) async {});
        return bloc;
      },
      act: (bloc) => bloc.add(StartListeningEvent()),
      expect: () => [const PracticeSpeakingState(isListening: true)],
    );

    blocTest<PracticeSpeakingBloc, PracticeSpeakingState>(
      'StopListeningEvent emits isListening=false',
      build: () {
        when(() => mockSpeech.stopListening()).thenAnswer((_) async {});
        return bloc;
      },
      seed: () => const PracticeSpeakingState(isListening: true),
      act: (bloc) => bloc.add(StopListeningEvent()),
      expect: () => [const PracticeSpeakingState(isListening: false)],
    );

    blocTest<PracticeSpeakingBloc, PracticeSpeakingState>(
      'SpeechResultEvent updates recognizedText',
      build: () => bloc,
      act: (bloc) => bloc.add(const SpeechResultEvent('Hello')),
      expect: () => [const PracticeSpeakingState(recognizedText: 'Hello')],
    );

    blocTest<PracticeSpeakingBloc, PracticeSpeakingState>(
      'SpeechErrorEvent updates error',
      build: () => bloc,
      act: (bloc) => bloc.add(const SpeechErrorEvent('Mic error')),
      expect: () => [const PracticeSpeakingState(error: 'Mic error', isListening: false)],
    );
  });

  group('Navigation events', () {
    final q1 = InterviewQuestion(question: 'Q1');
    final q2 = InterviewQuestion(question: 'Q2');

    blocTest<PracticeSpeakingBloc, PracticeSpeakingState>(
      'MoveToNextQuestionEvent updates index',
      build: () => bloc,
      seed: () => PracticeSpeakingState(
        questions: [q1, q2],
        currentQuestionIndex: 0,
        currentQuestion: q1,
      ),
      act: (bloc) => bloc.add(MoveToNextQuestionEvent()),
      expect: () => [
        PracticeSpeakingState(
          questions: [q1, q2],
          currentQuestionIndex: 1,
          currentQuestion: q2,
        ),
      ],
    );

    blocTest<PracticeSpeakingBloc, PracticeSpeakingState>(
      'MoveToPreviousQuestionEvent updates index',
      build: () => bloc,
      seed: () => PracticeSpeakingState(
        questions: [q1, q2],
        currentQuestionIndex: 1,
        currentQuestion: q2,
      ),
      act: (bloc) => bloc.add(MoveToPreviousQuestionEvent()),
      expect: () => [
        PracticeSpeakingState(
          questions: [q1, q2],
          currentQuestion: q1,
        ),
      ],
    );
  });
}
