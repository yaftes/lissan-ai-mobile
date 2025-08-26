import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:lissan_ai/core/network/bloc/connectivity_bloc.dart';
import 'package:lissan_ai/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:lissan_ai/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:lissan_ai/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:lissan_ai/core/network/network_info.dart';
import 'package:lissan_ai/features/auth/domain/usecases/get_token_usecase.dart';
import 'package:lissan_ai/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:lissan_ai/features/auth/domain/usecases/sign_in_with_token_usecase.dart';
import 'package:lissan_ai/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:lissan_ai/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:lissan_ai/features/auth/presentation/bloc/auth_bloc.dart';

GetIt getIt = GetIt.instance;

void init() {
  // ----------------------
  // Core / external deps
  // ----------------------
  getIt.registerLazySingleton(() => InternetConnection());
  getIt.registerLazySingleton(() => InternetConnectionChecker.createInstance());
  getIt.registerLazySingleton(() => const FlutterSecureStorage());
  getIt.registerLazySingleton<http.Client>(() => IOClient(HttpClient()));

  // ----------------------
  // ConnectivityBloc using plus version
  // ----------------------
  getIt.registerFactory(
    () => ConnectivityBloc(connection: getIt<InternetConnection>()),
  );

  // ----------------------
  // Auth data sources
  // ----------------------
  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(storage: getIt<FlutterSecureStorage>()),
  );

  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      client: getIt<http.Client>(),
      localDataSource: getIt<AuthLocalDataSource>(),
    ),
  );

  // ----------------------
  // Network info using original checker
  // ----------------------
  getIt.registerLazySingleton<NetworkInfo>(
    () =>
        NetworkInfoImpl(connectionChecker: getIt<InternetConnectionChecker>()),
  );

  // ----------------------
  // Auth repository
  // ----------------------
  getIt.registerLazySingleton<AuthRepositoryImpl>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt<AuthRemoteDataSource>(),
      localDataSource: getIt<AuthLocalDataSource>(),
      networkInfo: getIt<NetworkInfo>(),
    ),
  );

  // let's register the usecase then the auth bloc
  getIt.registerFactory(
    () => SignUpUsecase(repository: getIt<AuthRepositoryImpl>()),
  );
  getIt.registerFactory(
    () => SignInUsecase(repository: getIt<AuthRepositoryImpl>()),
  );
  getIt.registerFactory(
    () => SignOutUsecase(repository: getIt<AuthRepositoryImpl>()),
  );
  getIt.registerFactory(
    () => SignInWithTokenUsecase(repository: getIt<AuthRepositoryImpl>()),
  );
  getIt.registerFactory(
    () => GetTokenUsecase(repository: getIt<AuthRepositoryImpl>()),
  );

  // now let's register the auth bloc

  getIt.registerFactory(
    () => AuthBloc(
      signInUsecase: getIt<SignInUsecase>(),
      signOutUsecase: getIt<SignOutUsecase>(),
      signUpUsecase: getIt<SignUpUsecase>(),
      getTokenUsecase: getIt<GetTokenUsecase>(),
      signInWithTokenUsecase: getIt<SignInWithTokenUsecase>(),
    ),
  );
}
