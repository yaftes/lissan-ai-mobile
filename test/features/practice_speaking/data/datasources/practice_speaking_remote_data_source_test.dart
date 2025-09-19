import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:lissan_ai/core/error/exceptions.dart';
import 'package:lissan_ai/core/utils/constants/practice_speaking_constants.dart';
import 'package:lissan_ai/core/utils/helper/api_client_helper.dart';
import 'package:lissan_ai/features/practice_speaking/data/datasources/practice_speaking_remote_data_source.dart';
import 'package:lissan_ai/features/practice_speaking/data/models/answer_feed_back_model.dart';
import 'package:lissan_ai/features/practice_speaking/data/models/interview_question_model.dart';
import 'package:lissan_ai/features/practice_speaking/data/models/practice_session_result_model.dart';
import 'package:lissan_ai/features/practice_speaking/data/models/practice_session_start.dart';
import 'package:lissan_ai/features/practice_speaking/domain/entities/user_answer.dart';
import 'package:mocktail/mocktail.dart';

class MockApiClientHelper extends Mock implements ApiClientHelper {}

void main() {
  late MockApiClientHelper mockApiClientHelper;
  late PracticeSpeakingRemoteDataSourceImpl dataSource;

  setUp(() {
    mockApiClientHelper = MockApiClientHelper();
    dataSource = PracticeSpeakingRemoteDataSourceImpl(apiClientHelper: mockApiClientHelper);
  });

  
  void setUpMockHttpClientSuccess(http.Response response, {required Uri url, Map<String, dynamic>? body}) {
    if (body != null) {
      
      when(() => mockApiClientHelper.post(url.toString(), body)).thenAnswer((_) async => response);
    } else {
      
      when(() => mockApiClientHelper.get(url.toString())).thenAnswer((_) async => response);
    }
  }

  
  void setUpMockHttpClientFailure(int statusCode, {required Uri url, Map<String, dynamic>? body}) {
    final response = http.Response('{"error": "Error message"}', statusCode);
     if (body != null) {
      
      when(() => mockApiClientHelper.post(url.toString(), body)).thenAnswer((_) async => response);
    } else {
      
      when(() => mockApiClientHelper.get(url.toString())).thenAnswer((_) async => response);
    }
  }


  group('startPracticeSession', () {
    const tType = 'general';
    final tBody = {'type': tType};
    final tUri = Uri.parse(PracticeSpeakingConstants.startSession);
    final tPracticeSessionStartModel = PracticeSessionStartModel.fromJson(const {'session_id': '123'});

    test('should return PracticeSessionStart when the response code is 200 (success)', () async {
      
      setUpMockHttpClientSuccess(
        http.Response(jsonEncode({'session_id': '123'}), 200),
        url: tUri,
        body: tBody,
      );

      
      final result = await dataSource.startPracticeSession(tType);

      
      expect(result, equals(tPracticeSessionStartModel));
      verify(() => mockApiClientHelper.post(tUri.toString(), tBody)).called(1);
      verifyNoMoreInteractions(mockApiClientHelper);
    });

    test('should throw a ServerException when the response code is 500 or other', () async {
      
      setUpMockHttpClientFailure(500, url: tUri, body: tBody);

      
      final call = dataSource.startPracticeSession;

      
      expect(() => call(tType), throwsA(isA<ServerException>()));
      verify(() => mockApiClientHelper.post(tUri.toString(), tBody)).called(1);
      verifyNoMoreInteractions(mockApiClientHelper);
    });
  });

  group('getInterviewQuestion', () {
    const tSessionId = '123';
    final tUri = Uri.parse(PracticeSpeakingConstants.getQuestion(tSessionId));
    final tInterviewQuestionModel = InterviewQuestionModel.fromJson(const {'question': 'Tell me about yourself'});

    test('should return InterviewQuestion when the response code is 200 (success)', () async {
      
      setUpMockHttpClientSuccess(
        http.Response(jsonEncode({'question': 'Tell me about yourself'}), 200),
        url: tUri,
      );

      
      final result = await dataSource.getInterviewQuestion(tSessionId);

      
      expect(result, equals(tInterviewQuestionModel));
      verify(() => mockApiClientHelper.get(tUri.toString())).called(1);
      verifyNoMoreInteractions(mockApiClientHelper);
    });

    test('should throw a NotFoundException when the response code is 404', () async {
      
      setUpMockHttpClientFailure(404, url: tUri);

      
      final call = dataSource.getInterviewQuestion;

      
      expect(() => call(tSessionId), throwsA(isA<NotFoundException>()));
      verify(() => mockApiClientHelper.get(tUri.toString())).called(1);
      verifyNoMoreInteractions(mockApiClientHelper);
    });
  });

  group('answerAndGetFeedback', () {
    final tUserAnswer = UserAnswer(sessionId: '123', transcript: 'My answer');
    final tBody = {'session_id': tUserAnswer.sessionId, 'answer': tUserAnswer.transcript};
    final tUri = Uri.parse(PracticeSpeakingConstants.submitAnswer);
    final tAnswerFeedbackModel = AnswerFeedbackModel.fromJson(const {'feedback': 'Good answer'});

    test('should return AnswerFeedback when the response code is 200 (success)', () async {
      
      setUpMockHttpClientSuccess(
        http.Response(jsonEncode({'feedback': 'Good answer'}), 200),
        url: tUri,
        body: tBody,
      );

      
      final result = await dataSource.answerAndGetFeedback(tUserAnswer);

      
      expect(result, equals(tAnswerFeedbackModel));
      verify(() => mockApiClientHelper.post(tUri.toString(), tBody)).called(1);
      verifyNoMoreInteractions(mockApiClientHelper);
    });

    test('should throw a BadRequestException when the response code is 400', () async {
      
      setUpMockHttpClientFailure(400, url: tUri, body: tBody);

      
      final call = dataSource.answerAndGetFeedback;

      
      expect(() => call(tUserAnswer), throwsA(isA<BadRequestException>()));
      verify(() => mockApiClientHelper.post(tUri.toString(), tBody)).called(1);
      verifyNoMoreInteractions(mockApiClientHelper);
    });
  });

  group('endPracticeSession', () {
    const tSessionId = '123';
    final tBody = {'session_id': tSessionId};
    final tUri = Uri.parse(PracticeSpeakingConstants.endSession(tSessionId));
    final tPracticeSessionResultModel = PracticeSessionResultModel.fromJson(const {'score': 95.5});

    test('should return PracticeSessionResult when the response code is 200 (success)', () async {
      
      setUpMockHttpClientSuccess(
        http.Response(jsonEncode({'score': 95.5}), 200),
        url: tUri,
        body: tBody,
      );

      
      final result = await dataSource.endPracticeSession(tSessionId);

      
      expect(result, equals(tPracticeSessionResultModel));
      verify(() => mockApiClientHelper.post(tUri.toString(), tBody)).called(1);
      verifyNoMoreInteractions(mockApiClientHelper);
    });

    test('should throw an UnAuthorizedException when the response code is 401', () async {
      
      setUpMockHttpClientFailure(401, url: tUri, body: tBody);

      
      final call = dataSource.endPracticeSession;

      
      expect(() => call(tSessionId), throwsA(isA<UnAuthorizedException>()));
      verify(() => mockApiClientHelper.post(tUri.toString(), tBody)).called(1);
      verifyNoMoreInteractions(mockApiClientHelper);
    });
  });
}