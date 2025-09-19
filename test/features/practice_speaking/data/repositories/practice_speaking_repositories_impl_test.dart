import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lissan_ai/core/error/exceptions.dart';
import 'package:lissan_ai/core/error/failure.dart';
import 'package:lissan_ai/core/network/network_info.dart';
import 'package:lissan_ai/features/practice_speaking/data/datasources/practice_speaking_remote_data_source.dart';
import 'package:lissan_ai/features/practice_speaking/data/repositories/practice_speaking_repositories_impl.dart';
import 'package:lissan_ai/features/practice_speaking/domain/entities/answer_feed_back.dart';
import 'package:lissan_ai/features/practice_speaking/domain/entities/interview_question.dart';
import 'package:lissan_ai/features/practice_speaking/domain/entities/practice_session_result.dart';
import 'package:lissan_ai/features/practice_speaking/domain/entities/practice_session_start.dart';
import 'package:lissan_ai/features/practice_speaking/domain/entities/user_answer.dart';
import 'package:mocktail/mocktail.dart';

// Mock classes
class MockRemoteDataSource extends Mock implements PracticeSpeakingRemoteDataSource {}
class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late PracticeSpeakingRepositoriesImpl repository;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = PracticeSpeakingRepositoriesImpl(
      remoteDataSource: mockRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  /// Helper to test both online/offline scenarios
  void runTestsOnlineAndOffline<T>({
    required String description,
    required Future<T> Function() remoteCall,
    required Future<Either<Failure, T>> Function() action,
    required T expectedValue,
  }) {
    group(description, () {
      group('device is online', () {
        setUp(() {
          when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        });

        test('should return remote data when call is successful', () async {
          // arrange
          when(remoteCall).thenAnswer((_) async => expectedValue);

          // act
          final result = await action();

          // assert
          expect(result, Right(expectedValue));
          verify(() => mockNetworkInfo.isConnected).called(1);
          verify(remoteCall).called(1);
        });

        test('should return ServerFailure when call throws ServerException', () async {
          // arrange
          when(remoteCall).thenThrow(const ServerException(message: 'Server Error'));

          // act
          final result = await action();

          // assert
          expect(result, const Left(ServerFailure(message: 'Server Error')));
          verify(() => mockNetworkInfo.isConnected).called(1);
          verify(remoteCall).called(1);
        });
      });

      group('device is offline', () {
        setUp(() {
          when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        });

        test('should return NetworkFailure when offline', () async {
          // act
          final result = await action();

          // assert
          expect(result, const Left(NetworkFailure(message: 'No internet connection')));
          verify(() => mockNetworkInfo.isConnected).called(1);
          verifyZeroInteractions(mockRemoteDataSource);
        });
      });
    });
  }


  group('startPracticeSession', () {
    const tType = 'general';
    final tPracticeSessionStart = PracticeSessionStart(sessionId: '123', questionNumber: 1);

    runTestsOnlineAndOffline<PracticeSessionStart>(
      description: 'start practice session',
      remoteCall: () => mockRemoteDataSource.startPracticeSession(tType),
      action: () => repository.startPracticeSession(tType),
      expectedValue: tPracticeSessionStart,
    );
  });

  group('getInterviewQuestion', () {
    const tSessionId = '123';
    final tInterviewQuestion = InterviewQuestion(question: 'Tell me about yourself?');

    runTestsOnlineAndOffline<InterviewQuestion>(
      description: 'get interview question',
      remoteCall: () => mockRemoteDataSource.getInterviewQuestion(tSessionId),
      action: () => repository.getInterviewQuestion(tSessionId),
      expectedValue: tInterviewQuestion,
    );
  });

  group('submitAndGetAnswer', () {
    final tUserAnswer = UserAnswer(sessionId: '123', transcript: 'My answer');
    final tAnswerFeedback = AnswerFeedback(overallSummary: 'Good', feedbackPoints: [], scorePercentage: 90);

    runTestsOnlineAndOffline<AnswerFeedback>(
      description: 'submit and get answer',
      remoteCall: () => mockRemoteDataSource.answerAndGetFeedback(tUserAnswer),
      action: () => repository.submitAndGetAnswer(tUserAnswer),
      expectedValue: tAnswerFeedback,
    );
  });

  group('endPracticeSession', () {
    const tSessionId = '123';
    final tPracticeSessionResult = PracticeSessionResult(
      sessionId: '123',
      totalQuestions: 5,
      completed: 4,
      strengths: [],
      weaknesses: [],
      finalScore: 80,
      createdAt: 123456,
    );

    runTestsOnlineAndOffline<PracticeSessionResult>(
      description: 'end practice session',
      remoteCall: () => mockRemoteDataSource.endPracticeSession(tSessionId),
      action: () => repository.endPracticeSession(tSessionId),
      expectedValue: tPracticeSessionResult,
    );
  });

  group('_execute exception handling', () {
    const tSessionId = '123';

    setUp(() {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    });

    test('should return ValidationFailure on BadRequestException', () async {
      when(() => mockRemoteDataSource.endPracticeSession(tSessionId))
          .thenThrow(const BadRequestException(message: 'Bad request'));

      final result = await repository.endPracticeSession(tSessionId);

      expect(result, const Left(ValidationFailure(message: 'Bad request')));
    });

    test('should return UnauthorizedFailure on UnAuthorizedException', () async {
      when(() => mockRemoteDataSource.endPracticeSession(tSessionId))
          .thenThrow(const UnAuthorizedException(message: 'Unauthorized'));

      final result = await repository.endPracticeSession(tSessionId);

      expect(result, const Left(UnauthorizedFailure(message: 'Unauthorized')));
    });

    test('should return NotFoundFailure on NotFoundException', () async {
      when(() => mockRemoteDataSource.endPracticeSession(tSessionId))
          .thenThrow(const NotFoundException(message: 'Not found'));

      final result = await repository.endPracticeSession(tSessionId);

      expect(result, const Left(NotFoundFailure(message: 'Not found')));
    });

    test('should return ConflictFailure on ConflictException', () async {
      when(() => mockRemoteDataSource.endPracticeSession(tSessionId))
          .thenThrow(const ConflictException(message: 'Conflict'));

      final result = await repository.endPracticeSession(tSessionId);

      expect(result, const Left(ConflictFailure(message: 'Conflict')));
    });
  });
}
