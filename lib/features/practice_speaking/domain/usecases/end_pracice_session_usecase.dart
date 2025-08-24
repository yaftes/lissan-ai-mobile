import 'package:dartz/dartz.dart';
import 'package:lissan_ai/core/error/failure.dart';
import 'package:lissan_ai/features/practice_speaking/domain/entities/practice_session.dart';
import 'package:lissan_ai/features/practice_speaking/domain/repositories/speaking_practice_repository.dart';

class EndPraciceSessionUsecase {
  final SpeakingPracticeRepository repository;
  EndPraciceSessionUsecase({required this.repository});

  Future<Either<Failure, PracticeSession>> call(){
    return repository.endPracticeSession();
  }
}