import 'package:dartz/dartz.dart';
import 'package:lissan_ai/core/error/failure.dart';
import 'package:lissan_ai/features/auth/domain/entities/user.dart';
import 'package:lissan_ai/features/auth/domain/repositories/auth_repository.dart';

class SignInWithGoogleUsecase {
  final AuthRepository repository;
  SignInWithGoogleUsecase({required this.repository});
  Future<Either<Failure, User>> call(String token) {
    return repository.signInWithGoogle(token);
  }
}
