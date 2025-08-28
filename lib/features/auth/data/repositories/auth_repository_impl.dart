import 'package:dartz/dartz.dart';
import 'package:lissan_ai/core/error/exceptions.dart';
import 'package:lissan_ai/core/error/failure.dart';
import 'package:lissan_ai/core/network/network_info.dart';
import 'package:lissan_ai/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:lissan_ai/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:lissan_ai/features/auth/domain/entities/user.dart';
import 'package:lissan_ai/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, User>> signIn(User user) async {
    if (await networkInfo.isConnected) {
      try {
        final data = await remoteDataSource.signIn(user);
        return Right(data);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on CacheException catch (e) {
        return Left(CacheFailure(message: e.message));
      } catch (e) {
        return Left(UnexpectedFailure(message: e.toString()));
      }
    }
    return const Left(NetworkFailure(message: 'No internet connection'));
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.signOut();
        return const Right(unit);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on CacheException catch (e) {
        return Left(CacheFailure(message: e.message));
      } catch (e) {
        return Left(UnexpectedFailure(message: e.toString()));
      }
    }
    return const Left(NetworkFailure(message: 'No internet connection'));
  }

  @override
  Future<Either<Failure, User>> signUp(User user) async {
    if (await networkInfo.isConnected) {
      try {
        final data = await remoteDataSource.signUp(user);
        return Right(data);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on CacheException catch (e) {
        return Left(CacheFailure(message: e.message));
      } catch (e) {
        return Left(UnexpectedFailure(message: e.toString()));
      }
    }
    return const Left(NetworkFailure(message: 'No internet connection'));
  }

  @override
  Future<Either<Failure, User>> signInWithToken() async {
    // here we don't have to check the internet connection
    if (await networkInfo.isConnected) {
      try {
        final data = await remoteDataSource.signInWithToken();
        return Right(data);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on CacheException catch (e) {
        return Left(CacheFailure(message: e.message));
      } catch (e) {
        return Left(UnexpectedFailure(message: e.toString()));
      }
    }
    return const Left(NetworkFailure(message: 'No internet connection'));
  }

  @override
  Future<bool> isTokenValid() async {
    try {
      final accessToken = await localDataSource.getAccessToken();
      final expiryTime = await localDataSource.getExpiryTime();
      final now = DateTime.now().millisecondsSinceEpoch;

      // Token exists and is not expired
      if (accessToken != null &&
          accessToken.isNotEmpty &&
          (expiryTime == null || now < expiryTime)) {
        return true;
      }

      return false;
    } catch (e) {
      // If any error occurs, consider token invalid
      return false;
    }
  }

  @override
  Future<Either<Failure, User>> signInWithGoogle(String token) {
    // TODO: implement signInWithGoogle
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, User>> signUpWithGoogle() {
    // TODO: implement signUpWithGoogle
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Unit>> deleteAccount() {
    // TODO: implement deleteAccount
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Unit>> forgotPassword() {
    // TODO: implement forgotPassword
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Unit>> updateProfile(User user) {
    // TODO: implement updateProfile
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> hasConnectedToInternet() {
    // TODO: implement hasConnectedToInternet
    throw UnimplementedError();
  }
}
