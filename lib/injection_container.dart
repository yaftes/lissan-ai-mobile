import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:lissan_ai/core/network/bloc/connectivity_bloc.dart';
import 'package:lissan_ai/core/network/network_info.dart';
import 'package:lissan_ai/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:lissan_ai/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:lissan_ai/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:lissan_ai/features/auth/domain/repositories/auth_repository.dart';
import 'package:lissan_ai/features/auth/domain/usecases/get_token_usecase.dart';
import 'package:lissan_ai/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:lissan_ai/features/auth/domain/usecases/sign_in_with_token_usecase.dart';
import 'package:lissan_ai/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:lissan_ai/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:lissan_ai/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lissan_ai/features/writting_assistant/data/datasources/email_remote_data_source.dart';
import 'package:lissan_ai/features/writting_assistant/data/datasources/grammar_remote_data_sources.dart';
import 'package:lissan_ai/features/writting_assistant/data/repositories/email_repository_impl.dart';
import 'package:lissan_ai/features/writting_assistant/data/repositories/grammar_repository_impl.dart';
import 'package:lissan_ai/features/writting_assistant/domain/repositories/email_repository.dart';
import 'package:lissan_ai/features/writting_assistant/domain/repositories/grammar_repository.dart';
import 'package:lissan_ai/features/writting_assistant/domain/usecases/check_grammar_usecase.dart';
import 'package:lissan_ai/features/writting_assistant/domain/usecases/email_draft_usecase.dart';
import 'package:lissan_ai/features/writting_assistant/domain/usecases/email_improve_usecase.dart';
import 'package:lissan_ai/features/writting_assistant/presentation/bloc/writting_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt getIt = GetIt.instance;

Future<void> init() async {
  // ----------------------
  // Core / external deps
  // ----------------------
  getIt.registerLazySingleton(() => const FlutterSecureStorage());

  // You can just use the default client unless you need custom SgetIt handling
  getIt.registerLazySingleton<http.Client>(() => http.Client());

  // Using only the Plus checker (does both checking + listening)
  getIt.registerLazySingleton(() => InternetConnection());

  final sharedPreferences = await SharedPreferences.getInstance();

  // register the resolved object
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  // ----------------------
  // ConnectivityBloc
  // ----------------------
  getIt.registerFactory(
    () => ConnectivityBloc(connection: getIt<InternetConnection>()),
  );

  // ----------------------
  // Auth data sources
  // ----------------------
  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(
      storage: getIt<FlutterSecureStorage>(),
      sharedPreferences: getIt<SharedPreferences>(),
    ),
  );

  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      client: getIt<http.Client>(),
      localDataSource: getIt<AuthLocalDataSource>(),
    ),
  );

  // ----------------------
  // Network info
  // ----------------------
  getIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(connection: getIt<InternetConnection>()),
  );

  // ----------------------
  // Auth repository (registered as interface, not impl)
  // ----------------------
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt<AuthRemoteDataSource>(),
      localDataSource: getIt<AuthLocalDataSource>(),
      networkInfo: getIt<NetworkInfo>(),
    ),
  );

  // ----------------------
  // Auth usecases
  // ----------------------
  getIt.registerFactory(
    () => SignUpUsecase(repository: getIt<AuthRepository>()),
  );
  getIt.registerFactory(
    () => SignInUsecase(repository: getIt<AuthRepository>()),
  );
  getIt.registerFactory(
    () => SignOutUsecase(repository: getIt<AuthRepository>()),
  );
  getIt.registerFactory(
    () => SignInWithTokenUsecase(repository: getIt<AuthRepository>()),
  );
  getIt.registerFactory(
    () => GetTokenUsecase(repository: getIt<AuthRepository>()),
  );

  // ----------------------
  // Auth bloc
  // ----------------------
  getIt.registerFactory(
    () => AuthBloc(
      signInUsecase: getIt<SignInUsecase>(),
      signOutUsecase: getIt<SignOutUsecase>(),
      signUpUsecase: getIt<SignUpUsecase>(),
      getTokenUsecase: getIt<GetTokenUsecase>(),
      signInWithTokenUsecase: getIt<SignInWithTokenUsecase>(),
    ),
  );





  // ----------------------
  //  Writting feature 
  // ----------------------
  
  // Remote Data Sources
  getIt.registerLazySingleton<EmailRemoteDataSource>(
    () => EmailRemoteDataSourceImpl(client: getIt()),
  );

  getIt.registerLazySingleton<GrammarRemoteDataSources>(
    () => GrammarRemoteDataSourcesimpl(
      storage: getIt<FlutterSecureStorage>(),
      client: getIt<http.Client>(),
    ),
  );


  // Repositories
  getIt.registerLazySingleton<EmailRepository>(
    () => EmailRepositoryImpl(
      remoteDataSource: getIt<EmailRemoteDataSource>(),
      networkInfo: getIt<NetworkInfo>(),
    ),
  );

  getIt.registerLazySingleton<GrammarRepository>(
    () => GrammarRepositoryImpl(
      remoteDataSources: getIt<GrammarRemoteDataSources>(),
      networkInfo: getIt<NetworkInfo>(),
    ),
  );

  // Use Cases
  getIt.registerLazySingleton(
    () => EmailDraftUsecase(repository: getIt<EmailRepository>()),
  );

  getIt.registerLazySingleton(
    () => EmailImproveUsecase(repository: getIt<EmailRepository>()),
  );

  getIt.registerLazySingleton(
    () => CheckGrammarUsecase(repository: getIt<GrammarRepository>()),
  );

  // Bloc
  getIt.registerFactory(
    () => WrittingBloc(
      getEmailDraftUsecase: getIt<EmailDraftUsecase>(),
      checkGrammarUsecase: getIt<CheckGrammarUsecase>(),
      improveEmailUsecase: getIt<EmailImproveUsecase>(),
    ),
  );

}
