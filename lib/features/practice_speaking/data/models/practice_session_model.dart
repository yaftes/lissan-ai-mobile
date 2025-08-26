import 'package:lissan_ai/features/practice_speaking/domain/entities/practice_session.dart';

class PracticeSessionModel extends PracticeSession {
  PracticeSessionModel({
    required super.sessionId,
    required super.type,
    required super.startTime,
    required super.endTime,
  });

  factory PracticeSessionModel.fromJson(Map<String, dynamic>json) {
    return PracticeSessionModel(
      sessionId: json['sessionId'],
      type: json['type'],
      startTime: json['startTime'],
      endTime: json['endTime'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'type': type,
      'startTime': startTime,
      'endTime': endTime,
    };
  }
}
