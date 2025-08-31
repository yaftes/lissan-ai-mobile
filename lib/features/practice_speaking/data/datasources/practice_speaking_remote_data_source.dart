import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:lissan_ai/core/error/failure.dart';
import 'package:lissan_ai/core/utils/constants/practice_speaking_constants.dart';
import 'package:lissan_ai/core/utils/helper/api_client_helper.dart';
import 'package:lissan_ai/features/practice_speaking/data/models/answer_feed_back_model.dart';
import 'package:lissan_ai/features/practice_speaking/data/models/interview_question_model.dart';
import 'package:lissan_ai/features/practice_speaking/data/models/practice_session_result_model.dart';
import 'package:lissan_ai/features/practice_speaking/data/models/practice_session_start.dart';
import 'package:lissan_ai/features/practice_speaking/domain/entities/answer_feed_back.dart';
import 'package:lissan_ai/features/practice_speaking/domain/entities/interview_question.dart';
import 'package:lissan_ai/features/practice_speaking/domain/entities/practice_session_result.dart';
import 'package:lissan_ai/features/practice_speaking/domain/entities/practice_session_start.dart';
import 'package:lissan_ai/features/practice_speaking/domain/entities/user_answer.dart';

abstract class PracticeSpeakingRemoteDataSource {
  Future<Either<Failure, InterviewQuestion>> getInterviewQuestion(String sessionId);
  Future<Either<Failure, AnswerFeedback>> answerAndGetFeedback(UserAnswer answer);
  Future<Either<Failure, PracticeSessionStart>> startPracticeSession(String type);
  Future<Either<Failure, PracticeSessionResult>> endPracticeSession(String sessionId);
}

class PracticeSpeakingRemoteDataSourceImpl
    implements PracticeSpeakingRemoteDataSource {
  final ApiClientHelper apiClientHelper;
  PracticeSpeakingRemoteDataSourceImpl({required this.apiClientHelper});
  @override
  Future<Either<Failure, PracticeSessionResult>> endPracticeSession(String sessionId) async{
    final response = await apiClientHelper.get(PracticeSpeakingConstants.endSession(sessionId));
    if(response.statusCode == 200){
      final decoded = json.decode(response.body);
      final data = decoded['summary'] as Map<String, dynamic>;
      return Right(PracticeSessionResultModel.fromJson(data));
    }
    else{
      return Left(ServerFailure(message: 'error ${response.statusCode}'));
    }
    
  }

  @override
  Future<Either<Failure, InterviewQuestion>> getInterviewQuestion(String sessionId) async{
     final String url = 'https://lissan-ai-backend-dev.onrender.com/api/v1/interview/question?session_id=$sessionId';
     final response = await apiClientHelper.get(url);
     print(response.body);
     print('');
     print('check');
     if(response.statusCode == 200 || response.statusCode == 201){
      final decoded = json.decode(response.body);
      final Map<String, dynamic> data = decoded;
      return Right(InterviewQuestionModel.fromJson(data));

     }
     else{
      return Left(ServerFailure(message: 'error on get interview ${response.statusCode}'));
     }
  }

  @override
  Future<Either<Failure, PracticeSessionStart>> startPracticeSession(String type) async{
    final Map<String, String> body = {'type': type};
    final response = await apiClientHelper.post(PracticeSpeakingConstants.startSession,
      body,
    );
    if(response.statusCode == 200 || response.statusCode == 201){
      final decoded = json.decode(response.body);
      final Map<String, dynamic> data = decoded;
      return Right(PracticeSessionStartModel.fromJson(data));
    }
    else{
      return Left(ServerFailure(message: 'error on start session ${response.statusCode}'));
    }
  }
  
  @override
  Future<Either<Failure, AnswerFeedback>> answerAndGetFeedback(UserAnswer answer) async{
    final Map<String, dynamic> body = {'session_id':answer.sessionId, 'answer':answer.transcript};
    final response = await apiClientHelper.post(PracticeSpeakingConstants.submitAnswer, body);
    print('response status code: ${response.statusCode}');
    // print('response body: ${response.body}');
    print(answer.sessionId);
    print(answer.transcript);
    if(response.statusCode == 200){
      final decoded = json.decode(response.body);
      final Map<String, dynamic> data = decoded;
      return Right(AnswerFeedbackModel.fromJson(data));
    }
    else{
      return Left(ServerFailure(message: 'error ${response.statusCode}'));
    }

  }
}
