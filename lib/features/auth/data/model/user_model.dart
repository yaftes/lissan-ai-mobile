import 'package:lissan_ai/features/auth/domain/entities/user.dart';

class UserModel extends User {

  UserModel({
    super.id,
    super.name,
    super.email,
    super.password,
    super.imagePath,
    super.skills,
    super.experiences,
    super.careerGoals,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['user']['id'],
      name: json['user']['name'],
      email: json['user']['email'],
      password: json['user']['password'],
      imagePath: json['user']['imagePath'],
      skills: List<String>.from(json['user']['skills'] ?? []),
      experiences: List<String>.from(json['user']['experiences'] ?? []),
      careerGoals: List<String>.from(json['user']['careerGoals'] ?? []),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'user': {
        'id': id,
        'name': name,
        'email': email,
        'password': password,
        'imagePath': imagePath,
        'skills': skills,
        'experiences': experiences,
        'careerGoals': careerGoals,
      },
    };
  }
}