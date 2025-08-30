import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lissan_ai/core/network/network_info.dart';
import 'package:lissan_ai/features/writting_assistant/data/datasources/grammar_remote_data_sources.dart';
import 'package:lissan_ai/features/writting_assistant/data/repositories/grammar_repository_impl.dart';
import 'package:lissan_ai/features/writting_assistant/domain/repositories/grammar_repository.dart';
import 'package:lissan_ai/features/writting_assistant/domain/usecases/check_grammar_usecase.dart';
import 'package:lissan_ai/features/writting_assistant/presentation/bloc/grammar_bloc.dart';

final sl = GetIt.instance; 

Future<void> init() async {
  // BLoC
  sl.registerFactory(() => GrammarBloc(checkGrammarUsecase: sl()));

  // Use cases
  sl.registerLazySingleton(() => CheckGrammarUsecase(sl()));

  // Repository
  sl.registerLazySingleton<GrammarRepository>(() => GrammarRepositoryImpl(remoteDataSources: sl(),networkInfo: sl()));

  // Data sources
  sl.registerLazySingleton<GrammarRemoteDataSources>(() => GrammarRemoteDataSourcesimpl(client: sl()));

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // External
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker.createInstance());
}
