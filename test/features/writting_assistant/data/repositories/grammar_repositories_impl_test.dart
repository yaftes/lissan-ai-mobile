import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:lissan_ai/core/error/failure.dart';
import 'package:lissan_ai/core/network/network_info.dart';
import 'package:lissan_ai/features/writting_assistant/data/datasources/grammar_remote_data_sources.dart';
import 'package:lissan_ai/features/writting_assistant/data/model/grammar_result_model.dart';
import 'package:lissan_ai/features/writting_assistant/data/model/correction_model.dart';
import 'package:lissan_ai/features/writting_assistant/data/model/explanation_model.dart';
import 'package:lissan_ai/features/writting_assistant/data/repositories/grammar_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

class MockRemoteDataSource extends Mock implements GrammarRemoteDataSources {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late GrammarRepositoryImpl repository;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = GrammarRepositoryImpl(
      remoteDataSources: mockRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  const tEnglishText = 'helo world';

  final tGrammarResultModel = GrammarResultModel(
    correctedText: 'hello world',
    corrections: [
      CorrectionModel(
        originalPhrase: 'helo',
        correctedPhrase: 'hello',
        explanation: ExplanationModel(
          english: 'Spelling correction',
          amharic: 'የተሳሳተ ፊደል ማስተካከያ',
        ),
      )
    ],
  );

  group('checkGrammar', () {
    test(
        'should return GrammarResult when network is connected and remote succeeds',
        () async {
      // arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.checkGrammar(any()))
          .thenAnswer((_) async => tGrammarResultModel);

      // act
      final result = await repository.checkGrammar(tEnglishText);

      // assert
      expect(result, Right(tGrammarResultModel));
      verify(() => mockRemoteDataSource.checkGrammar(tEnglishText));
      verify(() => mockNetworkInfo.isConnected);
    });

    test(
        'should return ServerFailure when network is connected but remote throws',
        () async {
      // arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.checkGrammar(any()))
          .thenThrow(Exception('Server error'));

      // act
      final result = await repository.checkGrammar(tEnglishText);

      // assert
      expect(result, isA<Left<Failure, dynamic>>());
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('Should not return Right'),
      );
      verify(() => mockRemoteDataSource.checkGrammar(tEnglishText));
      verify(() => mockNetworkInfo.isConnected);
    });

    test(
        'should return No internet connection when network is not connected',
        () async {
      // arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      // act
      final result = await repository.checkGrammar(tEnglishText);

      // assert
      expect(
        result,
        const Left(ServerFailure(message: 'No internet connection')),
      );
      verifyNever(() => mockRemoteDataSource.checkGrammar(any()));
      verify(() => mockNetworkInfo.isConnected);
    });
  });
}
