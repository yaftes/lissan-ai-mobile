import 'package:dartz/dartz.dart';
import 'package:lissan_ai/core/error/failure.dart';
import 'package:lissan_ai/features/auth/domain/entities/user.dart';
import 'package:lissan_ai/features/auth/domain/repositories/auth_repository.dart';

class UpdateProfileUsecase {
  final AuthRepository repository;
  UpdateProfileUsecase({required this.repository});
  Future<Either<Failure, Unit>> call(User user) {
    return repository.updateProfile(user);
  }
}
