import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:lissan_ai/features/writting_assistant/data/datasources/grammar_remote_data_sources.dart';
import 'package:mocktail/mocktail.dart';

import 'package:lissan_ai/core/error/exceptions.dart';
import 'package:lissan_ai/core/utils/constants/auth_constants.dart';
import 'package:lissan_ai/core/utils/constants/writting_constant.dart';
import 'package:lissan_ai/features/writting_assistant/data/model/grammar_result_model.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockSecureStorage extends Mock implements FlutterSecureStorage {}

class FakeUri extends Fake implements Uri {}

void main() {
  setUpAll(() {
    // Register fallback for Uri so we can use any<Uri>()
    registerFallbackValue(FakeUri());
  });

  late GrammarRemoteDataSourcesImpl dataSource;
  late MockHttpClient mockClient;
  late MockSecureStorage mockStorage;

  setUp(() {
    mockClient = MockHttpClient();
    mockStorage = MockSecureStorage();
    dataSource = GrammarRemoteDataSourcesImpl(
      storage: mockStorage,
      client: mockClient,
    );
  });

  group('checkGrammar', () {
    const tText = 'This is a test sentence';
    const tToken = 'fake_token';

    final tUrl = Uri.parse(
      writting_constant.baseUrl + writting_constant.checkGrammarEndpoint,
    );

    final tGrammarResultJson = {
      'corrections': [
        {
          'original_phrase': 'This is a test sentence',
          'corrected_phrase': 'This is a test sentence.',
          'explanation': {'reason': 'Missing period at the end.'},
        },
      ],
    };

    test('should return GrammarResultModel when response is 200', () async {
      // arrange
      when(
        () => mockStorage.read(key: AuthConstants.accessToken),
      ).thenAnswer((_) async => tToken);

      when(
        () => mockClient.post(
          tUrl,
          headers: any(named: 'headers'),
          body: jsonEncode({'text': tText}),
        ),
      ).thenAnswer(
        (_) async => http.Response(jsonEncode(tGrammarResultJson), 200),
      );

      // act
      final result = await dataSource.checkGrammar(tText);

      // assert
      expect(result, isA<GrammarResultModel>());
      expect(
        result.corrections.first.correctedPhrase,
        equals('This is a test sentence.'),
      );
      verify(() => mockStorage.read(key: AuthConstants.accessToken)).called(1);
      verify(
        () => mockClient.post(
          any(),
          headers: any(named: 'headers'),
          body: any(named: 'body'),
        ),
      ).called(1);
    });

    test('should throw ServerException when token is null', () async {
      // arrange
      when(
        () => mockStorage.read(key: AuthConstants.accessToken),
      ).thenAnswer((_) async => null);

      // act
      final call = dataSource.checkGrammar;

      // assert
      expect(() => call(tText), throwsA(isA<ServerException>()));
      verify(() => mockStorage.read(key: AuthConstants.accessToken)).called(1);
      verifyNever(
        () => mockClient.post(
          any(),
          headers: any(named: 'headers'),
          body: any(named: 'body'),
        ),
      );
    });

    test(
      'should throw ServerException when response code is not 200',
      () async {
        // arrange
        when(
          () => mockStorage.read(key: AuthConstants.accessToken),
        ).thenAnswer((_) async => tToken);

        when(
          () => mockClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          ),
        ).thenAnswer((_) async => http.Response('Something went wrong', 400));

        // act & assert
        await expectLater(
          () => dataSource.checkGrammar(tText),
          throwsA(isA<ServerException>()),
        );

        verify(
          () => mockStorage.read(key: AuthConstants.accessToken),
        ).called(1);
        verify(
          () => mockClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          ),
        ).called(1);
      },
    );

    test('should throw ServerException when client throws exception', () async {
      // arrange
      when(
        () => mockStorage.read(key: AuthConstants.accessToken),
      ).thenAnswer((_) async => tToken);

      when(
        () => mockClient.post(
          any(),
          headers: any(named: 'headers'),
          body: any(named: 'body'),
        ),
      ).thenThrow(Exception('Network error'));

      // act
      final call = dataSource.checkGrammar;

      // assert
      expect(() => call(tText), throwsA(isA<ServerException>()));
    });
  });
}
