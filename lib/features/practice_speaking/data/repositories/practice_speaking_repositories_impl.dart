import 'package:dartz/dartz.dart';
import 'package:lissan_ai/core/error/failure.dart';
import 'package:lissan_ai/core/network/network_info.dart';
import 'package:lissan_ai/features/practice_speaking/data/datasources/practice_speaking_remote_data_source.dart';
import 'package:lissan_ai/features/practice_speaking/domain/entities/answer_feed_back.dart';
import 'package:lissan_ai/features/practice_speaking/domain/entities/interview_question.dart';
import 'package:lissan_ai/features/practice_speaking/domain/entities/practice_session.dart';
import 'package:lissan_ai/features/practice_speaking/domain/entities/user_answer.dart';
import 'package:lissan_ai/features/practice_speaking/domain/repositories/practice_speaking_repository.dart';

class PracticeSpeakingRepositoriesImpl implements PracticeSpeakingRepository {
  final NetworkInfo networkInfo;
  final PracticeSpeakingRemoteDataSource remoteDataSource;
  PracticeSpeakingRepositoriesImpl({
    required this.networkInfo,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, PracticeSession>> endPracticeSession(
    String sessionId,
  ) async {
    final isConnected = await networkInfo.isConnected;
    if(isConnected){
      try{
      return remoteDataSource.endPracticeSession(sessionId);
      }catch(e){
        return const Left(ServerFailure(message: 'server error'));
      }
    }
    else{
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, InterviewQuestion>> getInterviewQuestion(
    String sessionId,
  ) async{
    final isConnected = await networkInfo.isConnected;
    if(isConnected){
      try{
        return remoteDataSource.getInterviewQuestion(sessionId);
      }catch(e){
        return const Left(ServerFailure(message: ('server failure')));
      }
    }else{
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, PracticeSession>> startPracticeSession(String type) async{
    final isConnected = await networkInfo.isConnected;
    if(isConnected){
      try{
      return remoteDataSource.startPracticeSession(type);
      }catch(e){
        return const Left(ServerFailure(message: 'server error'));
      }
    }return const Left(NetworkFailure(message: 'no internet connection'));
  }

  @override
  Future<Either<Failure, AnswerFeedback>> submitAndGetAnswer(
    UserAnswer answer,
  ) async{
    final isConnected = await networkInfo.isConnected;
    if(isConnected){
      try{
        return remoteDataSource.answerAndGetFeedback(answer);
      }catch(e){
        return const Left(ServerFailure(message: 'server error'));
      }
    }else{
      return const Left(NetworkFailure(message: 'network error'));
    }
  }
  
  @override
  Future<Either<Failure, bool>> checkSpeechRecognitionAvailability() {
    // TODO: implement checkSpeechRecognitionAvailability
    throw UnimplementedError();
  }
  
  @override
  Future<Either<Failure, Stream<String>>> startSpeechRecognition() {
    // TODO: implement startSpeechRecognition
    throw UnimplementedError();
  }
  
  @override
  Future<Either<Failure, String>> stopSpeechRecognitionAndGetResult() {
    // TODO: implement stopSpeechRecognitionAndGetResult
    throw UnimplementedError();
  }
}
