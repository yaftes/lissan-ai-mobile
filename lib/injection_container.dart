// import 'dart:io';

// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:get_it/get_it.dart';
// import 'package:http/http.dart' as http;
// import 'package:http/io_client.dart';
// import 'package:internet_connection_checker/internet_connection_checker.dart';
// import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
// import 'package:lissan_ai/core/network/bloc/connectivity_bloc.dart';
// import 'package:lissan_ai/features/auth/data/datasources/auth_local_datasource.dart';
// import 'package:lissan_ai/features/auth/data/datasources/auth_remote_datasource.dart';
// import 'package:lissan_ai/features/auth/data/repositories/auth_repository_impl.dart';
// import 'package:lissan_ai/core/network/network_info.dart';
// import 'package:lissan_ai/features/auth/domain/usecases/get_token_usecase.dart';
// import 'package:lissan_ai/features/auth/domain/usecases/sign_in_usecase.dart';
// import 'package:lissan_ai/features/auth/domain/usecases/sign_in_with_token_usecase.dart';
// import 'package:lissan_ai/features/auth/domain/usecases/sign_out_usecase.dart';
// import 'package:lissan_ai/features/auth/domain/usecases/sign_up_usecase.dart';
// import 'package:lissan_ai/features/auth/presentation/bloc/auth_bloc.dart';

// GetIt getIt = GetIt.instance;

// void init() {
//   // ----------------------
//   // Core / external deps
//   // ----------------------
//   getIt.registerLazySingleton(() => InternetConnection());
//   getIt.registerLazySingleton(() => InternetConnectionChecker.createInstance());
//   getIt.registerLazySingleton(() => const FlutterSecureStorage());
//   getIt.registerLazySingleton<http.Client>(() => IOClient(HttpClient()));

//   // ----------------------
//   // ConnectivityBloc using plus version
//   // ----------------------
//   getIt.registerFactory(
//     () => ConnectivityBloc(connection: getIt<InternetConnection>()),
//   );

//   // ----------------------
//   // Auth data sources
//   // ----------------------
//   getIt.registerLazySingleton<AuthLocalDataSource>(
//     () => AuthLocalDataSourceImpl(storage: getIt<FlutterSecureStorage>()),
//   );

//   getIt.registerLazySingleton<AuthRemoteDataSource>(
//     () => AuthRemoteDataSourceImpl(
//       client: getIt<http.Client>(),
//       localDataSource: getIt<AuthLocalDataSource>(),
//     ),
//   );

//   // ----------------------
//   // Network info using original checker
//   // ----------------------
//   getIt.registerLazySingleton<NetworkInfo>(
//     () =>
//         NetworkInfoImpl(connectionChecker: getIt<InternetConnectionChecker>()),
//   );

//   // ----------------------
//   // Auth repository
//   // ----------------------
//   getIt.registerLazySingleton<AuthRepositoryImpl>(
//     () => AuthRepositoryImpl(
//       remoteDataSource: getIt<AuthRemoteDataSource>(),
//       localDataSource: getIt<AuthLocalDataSource>(),
//       networkInfo: getIt<NetworkInfo>(),
//     ),
//   );

//   // let's register the usecase then the auth bloc
//   getIt.registerFactory(
//     () => SignUpUsecase(repository: getIt<AuthRepositoryImpl>()),
//   );
//   getIt.registerFactory(
//     () => SignInUsecase(repository: getIt<AuthRepositoryImpl>()),
//   );
//   getIt.registerFactory(
//     () => SignOutUsecase(repository: getIt<AuthRepositoryImpl>()),
//   );
//   getIt.registerFactory(
//     () => SignInWithTokenUsecase(repository: getIt<AuthRepositoryImpl>()),
//   );
//   getIt.registerFactory(
//     () => GetTokenUsecase(repository: getIt<AuthRepositoryImpl>()),
//   );

//   // now let's register the auth bloc

//   getIt.registerFactory(
//     () => AuthBloc(
//       signInUsecase: getIt<SignInUsecase>(),
//       signOutUsecase: getIt<SignOutUsecase>(),
//       signUpUsecase: getIt<SignUpUsecase>(),
//       getTokenUsecase: getIt<GetTokenUsecase>(),
//       signInWithTokenUsecase: getIt<SignInWithTokenUsecase>(),
//     ),
//   );
// }

// lib/features/practice_speaking/injection_container.dart

import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lissan_ai/core/network/network_info.dart';
import 'package:lissan_ai/core/utils/helper/api_client_helper.dart';
import 'package:lissan_ai/features/practice_speaking/data/datasources/practice_speaking_remote_data_source.dart';
import 'package:lissan_ai/features/practice_speaking/data/repositories/practice_speaking_repositories_impl.dart';
import 'package:lissan_ai/features/practice_speaking/data/services/speech_to_text_service.dart';
import 'package:lissan_ai/features/practice_speaking/domain/repositories/practice_speaking_repository.dart';
import 'package:lissan_ai/features/practice_speaking/domain/usecases/end_pracice_session_usecase.dart';
import 'package:lissan_ai/features/practice_speaking/domain/usecases/get_interview_questions_usecase.dart';
import 'package:lissan_ai/features/practice_speaking/domain/usecases/recognize_speech.dart';
import 'package:lissan_ai/features/practice_speaking/domain/usecases/start_practice_session_usecase.dart';
import 'package:lissan_ai/features/practice_speaking/domain/usecases/submit_answer_and_get_feedback_usecase.dart';
import 'package:lissan_ai/features/practice_speaking/presentation/bloc/practice_speaking_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // -------------------------------
  // BLoC
  // -------------------------------
  sl.registerFactory<PracticeSpeakingBloc>(
    () => PracticeSpeakingBloc(
      startPracticeSessionUsecase: sl(),
      endPracticeSessionUsecase: sl(),
      getInterviewQuestionsUsecase: sl(),
      submitAndGetAnswerUsecase: sl(),
      recognizeSpeech: sl(),
    ),
  );

  // -------------------------------
  // Use cases
  // -------------------------------
  sl.registerLazySingleton<StartPracticeSessionUsecase>(
    () => StartPracticeSessionUsecase(repository: sl()),
  );
  sl.registerLazySingleton<EndPraciceSessionUsecase>(
    () => EndPraciceSessionUsecase(repository: sl()),
  );
  sl.registerLazySingleton<GetInterviewQuestionsUsecase>(
    () => GetInterviewQuestionsUsecase(repository: sl()),
  );
  sl.registerLazySingleton<SubmitAnswerAndGetFeedbackUsecase>(
    () => SubmitAnswerAndGetFeedbackUsecase(repository: sl()),
  );
  sl.registerLazySingleton<RecognizeSpeech>(
    () => RecognizeSpeech(service: sl()),
  );

  // -------------------------------
  // Repository
  // -------------------------------
  sl.registerLazySingleton<PracticeSpeakingRepository>(
    () => PracticeSpeakingRepositoriesImpl(
      networkInfo: sl(),
      remoteDataSource: sl(),
    ),
  );

  // -------------------------------
  // Services
  // -------------------------------
  sl.registerLazySingleton<SpeechToTextService>(() => SpeechToTextService());

  // -------------------------------
  // Core (example, add yours)
  // -------------------------------
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(connectionChecker: sl()),
  );
  sl.registerLazySingleton(() => ApiClientHelper(client: sl()));
  sl.registerLazySingleton<PracticeSpeakingRemoteDataSource>(
    () => PracticeSpeakingRemoteDataSourceImpl(apiClientHelper: sl()),
  );
  sl.registerLazySingleton<http.Client>(() => http.Client());
  // );

  // initialize service
  await sl<SpeechToTextService>().init();

  //external
  sl.registerLazySingleton<InternetConnectionChecker>(
    () => InternetConnectionChecker.instance,
  );
}
