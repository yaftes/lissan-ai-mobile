import 'package:dartz/dartz.dart';
import 'package:lissan_ai/core/error/failure.dart';
import 'package:lissan_ai/features/auth/domain/repositories/auth_repository.dart';

class ForgotPasswordUsecase {
  final AuthRepository repository;
  ForgotPasswordUsecase({required this.repository});
  Future<Either<Failure, Unit>> call() {
    return repository.forgotPassword();
  }
}
