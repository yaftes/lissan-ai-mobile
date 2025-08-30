import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:lissan_ai/core/error/failure.dart';
import 'package:lissan_ai/features/practice_speaking/domain/entities/user_answer.dart';
import 'package:lissan_ai/features/practice_speaking/domain/repositories/speaking_practice_repository.dart';

class SubmitAnswerAndGetFeedbackUsecase {
  final SpeakingPracticeRepository repository;
  SubmitAnswerAndGetFeedbackUsecase({required this.repository});

  Future<Either<Failure, Feedback>> call(UserAnswer answer){
    return repository.getFeedBack(answer);
  }
}