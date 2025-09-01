import 'package:lissan_ai/features/writting_assistant/domain/entities/email_improve.dart';

class ImprovedEmailModel extends EmailImprove {
  const ImprovedEmailModel({
    required super.subject,
    required super.improvedBody,
  });

  factory ImprovedEmailModel.fromJson(Map<String, dynamic> json) {
    return ImprovedEmailModel(
      improvedBody: json['body'] ?? '',
      subject: json['subject'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'body': improvedBody,
    };
  }
}
