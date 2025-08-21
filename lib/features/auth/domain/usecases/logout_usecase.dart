import 'package:dartz/dartz.dart';
import 'package:lissan_ai/core/error/failure.dart';
import 'package:lissan_ai/features/auth/domain/repositories/user_repository.dart';

class LogoutUsecase {
  final UserRepository repository;
  LogoutUsecase({required this.repository});
  Future<Either<Failure, Unit>> call(){
    return repository.logoutUser();
  }

}