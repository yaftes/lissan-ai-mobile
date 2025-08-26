import 'package:flutter/material.dart';
import 'package:lissan_ai/features/practice_speaking/domain/entities/interview_question.dart';
import 'package:lissan_ai/features/practice_speaking/domain/entities/user_answer.dart';

enum SessionType { freeSpeaking, mockInterview }

class PracticeSession {
  final String sessionId;
  final SessionType type;
  final List<InterviewQuestion> questions;   
  final List<UserAnswer> answers; 
  final List<Feedback> feedbacks;   
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  PracticeSession({
    required this.sessionId,
    required this.type,
    this.questions = const [],
    this.answers = const [],
    this.feedbacks = const [],
    required this.startTime,
    required this.endTime
  });
}
