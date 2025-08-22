import 'package:dartz/dartz.dart';
import 'package:lissan_ai/core/error/failure.dart';
import 'package:lissan_ai/core/network/network_info.dart';
import 'package:lissan_ai/features/auth/data/datasources/user_local_data_sources.dart';
import 'package:lissan_ai/features/auth/data/datasources/user_remote_data_sources.dart';
import 'package:lissan_ai/features/auth/data/model/user_model.dart';
import 'package:lissan_ai/features/auth/domain/entities/user.dart';
import 'package:lissan_ai/features/auth/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserLocalDataSource localDataSources;
  final UserRemoteDataSource remoteDataSources;
  final NetworkInfo networkInfo;

  UserRepositoryImpl({
    required this.localDataSources,
    required this.remoteDataSources,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, User>> registerUser(User user) async{
    if (await networkInfo.isConnected){
      try {
        final userModel = await remoteDataSources.registerUser(
          name: user.name!,
          email: user.email!,
          password: user.password!,
        );
        await localDataSources.cacheUser(userModel as UserModel);
        return Right(userModel);
      } catch (e) {
        return const Left(ServerFailure(message: 'Sign up failed'));
      }
    }
    else{
      return const Left(ServerFailure(message: 'NO INTERNET CONNECTION'));
    }
  }

  @override
  Future<Either<Failure, User>> loginUser(User user) async {
    if (await networkInfo.isConnected) {
      try {
        final userModel = await remoteDataSources.loginUser(
          email: user.email!,
          password: user.password!,
        );
        await localDataSources.cacheUser(userModel as UserModel);
        return Right(userModel);
      } catch (e) {
        return const Left(ServerFailure(message: 'Login failed'));
      }
    } else {
      try {
        final cachedUser = await localDataSources.getCachedUser();
        return Right(cachedUser);
      } catch (_) {
        return const Left(CacheFailure(message: 'Cache error'));
      }
    }
  }

  @override
  Future<Either<Failure, Unit>> logoutUser() async {
    try {
      final token = await localDataSources.getToken();
      
      if (await networkInfo.isConnected) {
        await remoteDataSources.logoutUser(token: token);
      }
      await localDataSources.clearCache();
      return const Right(unit);
    } catch (_) {
      return const Left(ServerFailure(message: 'Logout failed'));
    }
  }

}
