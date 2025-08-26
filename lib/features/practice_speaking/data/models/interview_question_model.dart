import 'package:lissan_ai/features/practice_speaking/domain/entities/interview_question.dart';

class InterviewQuestionModel extends InterviewQuestion {
  InterviewQuestionModel({required super.type, required super.text});

  factory InterviewQuestionModel.fromJson(Map<String, dynamic> json){
    return InterviewQuestionModel(
      type: json['type'],
      text: json['text']
    );
  }
  Map<String, dynamic> toJson(){
    return {'type':type, 'text': text};
  }
  

  }


