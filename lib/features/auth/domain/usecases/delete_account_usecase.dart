import 'package:dartz/dartz.dart';
import 'package:lissan_ai/core/error/failure.dart';
import 'package:lissan_ai/features/auth/domain/repositories/auth_repository.dart';

class DeleteAccountUsecase {
  final AuthRepository repository;
  DeleteAccountUsecase({required this.repository});
  Future<Either<Failure, Unit>> call() {
    return repository.deleteAccount();
  }
}
