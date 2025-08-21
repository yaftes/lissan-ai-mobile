import 'package:dartz/dartz.dart';
import 'package:lissan_ai/core/error/failure.dart';
import 'package:lissan_ai/features/auth/domain/entities/user.dart';
import 'package:lissan_ai/features/auth/domain/repositories/user_repository.dart';

class LoginUsecase {
  final UserRepository repository;
  LoginUsecase({required this.repository});
  Future<Either<Failure, User>> call(User user){
    return repository.loginUser(user);
  }

}