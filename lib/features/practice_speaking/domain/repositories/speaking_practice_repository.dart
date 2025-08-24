import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:lissan_ai/core/error/failure.dart';
import 'package:lissan_ai/features/practice_speaking/domain/entities/interview_question.dart';
import 'package:lissan_ai/features/practice_speaking/domain/entities/practice_session.dart';
import 'package:lissan_ai/features/practice_speaking/domain/entities/user_answer.dart';

abstract class SpeakingPracticeRepository {
  Future<Either<Failure, List<InterviewQuestion>>> getInterviewQuestions();
  Future<Either<Failure, Feedback>> getFeedBack(UserAnswer answer);
  Future<Either<Failure, PracticeSession>> startPracticeSession();
  Future<Either<Failure, PracticeSession>> endPracticeSession();
}