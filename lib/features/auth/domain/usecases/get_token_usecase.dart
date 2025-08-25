import 'package:dartz/dartz.dart';
import 'package:lissan_ai/core/error/failure.dart';
import 'package:lissan_ai/features/auth/domain/repositories/auth_repository.dart';

class GetTokenUsecase {
  final AuthRepository authStorage;
  GetTokenUsecase({required this.authStorage});

  Future<Either<Failure, String>> call() {
    return authStorage.getToken();
  }
}
