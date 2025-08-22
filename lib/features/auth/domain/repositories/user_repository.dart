import 'package:dartz/dartz.dart';
import 'package:lissan_ai/core/error/failure.dart';
import 'package:lissan_ai/features/auth/domain/entities/user.dart';

abstract class UserRepository {
  Future<Either<Failure, User>> registerUser(User user);
  Future<Either<Failure, User>> loginUser(User user);
  Future<Either<Failure, Unit>> logoutUser();
}
