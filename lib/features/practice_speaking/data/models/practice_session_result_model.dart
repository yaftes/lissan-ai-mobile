import 'package:lissan_ai/features/practice_speaking/domain/entities/practice_session_result.dart';

class PracticeSessionResultModel extends PracticeSessionResult {
  PracticeSessionResultModel({
    required super.sessionId,
    required super.totalQuestions,
    required super.completed,
    super.strengths,
    super.weaknesses,
    required super.finalScore,
    required super.createdAt,
  });

  factory PracticeSessionResultModel.fromJson(Map<String, dynamic> json) {
    return PracticeSessionResultModel(
      sessionId: json['session_id'] as String,
      totalQuestions: json['total_questions'] as int,
      completed: json['completed'] as int,
      strengths: json['strengths'] as String?,
      weaknesses: json['weaknesses'] as String?,
      finalScore: json['final_score'] as int,
      createdAt: json['created_at'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'session_id': sessionId,
      'total_questions': totalQuestions,
      'completed': completed,
      'strengths': strengths,
      'weaknesses': weaknesses,
      'final_score': finalScore,
      'created_at': createdAt,
    };
  }
}
