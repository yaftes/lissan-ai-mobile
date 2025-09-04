import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lissan_ai/core/network/network_info.dart';
import 'package:lissan_ai/features/writting_assistant/data/datasources/grammar_remote_data_sources.dart';
import 'package:lissan_ai/features/writting_assistant/data/datasources/pronunciation_remote_data_source.dart';
import 'package:lissan_ai/features/writting_assistant/data/datasources/sentence_remote_data_source.dart';
import 'package:lissan_ai/features/writting_assistant/data/repositories/grammar_repository_impl.dart';
import 'package:lissan_ai/features/writting_assistant/data/repositories/pronunciation_repository_impl.dart';
import 'package:lissan_ai/features/writting_assistant/data/repositories/sentence_repository_impl.dart';
import 'package:lissan_ai/features/writting_assistant/domain/repositories/grammar_repository.dart';
import 'package:lissan_ai/features/writting_assistant/domain/repositories/pronunciation_repository.dart';
import 'package:lissan_ai/features/writting_assistant/domain/repositories/sentence_repository.dart';
import 'package:lissan_ai/features/writting_assistant/domain/usecases/check_grammar_usecase.dart';
import 'package:lissan_ai/features/writting_assistant/domain/usecases/get_sentence_usecase.dart';
import 'package:lissan_ai/features/writting_assistant/domain/usecases/send_pronunciation_usecase.dart';
import 'package:lissan_ai/features/writting_assistant/presentation/bloc/grammar_bloc.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  // -------------------- EXTERNAL --------------------
  getIt.registerLazySingleton(() => http.Client());
  getIt.registerLazySingleton(() => InternetConnectionChecker.createInstance());

  // -------------------- CORE --------------------
  getIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(getIt()),
  ); // depends on InternetConnectionChecker

  // -------------------- DATA SOURCES --------------------
  getIt.registerLazySingleton<GrammarRemoteDataSources>(
    () => GrammarRemoteDataSourcesimpl(client: getIt()),
  );
  getIt.registerLazySingleton<SentenceRemoteDataSource>(
    () => SentenceRemoteDataSourceImpl(client: getIt()),
  );
  getIt.registerLazySingleton<PronunciationRemoteDataSource>(
    () => PronunciationRemoteDataSourceImpl(client: getIt()),
  );

  // -------------------- REPOSITORIES --------------------
  getIt.registerLazySingleton<GrammarRepository>(
    () =>
        GrammarRepositoryImpl(remoteDataSources: getIt(), networkInfo: getIt()),
  );
  getIt.registerLazySingleton<SentenceRepository>(
    () => SentenceRepositoryImpl(remoteDataSource: getIt()),
  );
  getIt.registerLazySingleton<PronunciationRepository>(
    () => PronunciationRepositoryImpl(remoteDataSource: getIt()),
  );

  // -------------------- USE CASES --------------------
  getIt.registerLazySingleton(() => CheckGrammarUsecase(getIt()));
  getIt.registerLazySingleton(() => GetSentenceUsecase(getIt()));
  getIt.registerLazySingleton(() => SendPronunciationUsecase(getIt()));

  // -------------------- BLOC --------------------
  getIt.registerFactory(
    () => GrammarBloc(
      checkGrammarUsecase: getIt(),
      getSentenceUsecase: getIt(),
      sendPronunciationUsecase: getIt(),
    ),
  );
}
