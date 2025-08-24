import 'package:dartz/dartz.dart';
import 'package:lissan_ai/core/error/failure.dart';
import 'package:lissan_ai/features/practice_speaking/domain/entities/interview_question.dart';
import 'package:lissan_ai/features/practice_speaking/domain/repositories/speaking_practice_repository.dart';

class GetInterviewQuestionsUsecase {
  final SpeakingPracticeRepository repository;
  GetInterviewQuestionsUsecase({required this.repository});

  Future<Either<Failure, List<InterviewQuestion>>> call(){
    return repository.getInterviewQuestions();
  }

}