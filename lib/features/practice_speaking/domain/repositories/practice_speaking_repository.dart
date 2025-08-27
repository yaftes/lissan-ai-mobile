import 'package:dartz/dartz.dart';
import 'package:lissan_ai/core/error/failure.dart';
import 'package:lissan_ai/features/practice_speaking/domain/entities/answer_feed_back.dart';
import 'package:lissan_ai/features/practice_speaking/domain/entities/interview_question.dart';
import 'package:lissan_ai/features/practice_speaking/domain/entities/practice_session.dart';
import 'package:lissan_ai/features/practice_speaking/domain/entities/user_answer.dart';

abstract class PracticeSpeakingRepository {
  Future<Either<Failure, InterviewQuestion>> getInterviewQuestion(String sessionId);
  Future<Either<Failure, PracticeSession>> startPracticeSession(String type);
  Future<Either<Failure, PracticeSession>> endPracticeSession(String sessionId);
  Future<Either<Failure, AnswerFeedback>> submitAndGetAnswer(UserAnswer answer);

  Future<Either<Failure, Stream<String>>> startSpeechRecognition(); // To get real-time updates
  Future<Either<Failure, String>> stopSpeechRecognitionAndGetResult(); // To get the final text
  Future<Either<Failure, bool>> checkSpeechRecognitionAvailability(); // To check permissions etc.
}
