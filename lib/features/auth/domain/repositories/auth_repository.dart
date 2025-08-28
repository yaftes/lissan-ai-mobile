import 'package:dartz/dartz.dart';
import 'package:lissan_ai/core/error/failure.dart';
import 'package:lissan_ai/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> signUp(User user);
  Future<Either<Failure, User>> signIn(User user);
  Future<Either<Failure, Unit>> signOut();
  Future<Either<Failure, User>> signInWithToken();
  Future<bool> isTokenValid();

  Future<Either<Failure, User>> signInWithGoogle(String token);
  Future<Either<Failure, User>> signUpWithGoogle();

  Future<Either<Failure, Unit>> deleteAccount();
  Future<Either<Failure, Unit>> updateProfile(User user);
  Future<Either<Failure, Unit>> forgotPassword();
}
