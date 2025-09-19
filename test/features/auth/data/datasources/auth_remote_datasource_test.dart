import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;
import 'package:lissan_ai/core/error/exceptions.dart';
import 'package:lissan_ai/core/utils/constants/auth_constants.dart';
import 'package:lissan_ai/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:lissan_ai/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:lissan_ai/features/auth/data/models/user_model.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}

void main() {
  late MockHttpClient mockHttpClient;
  late MockAuthLocalDataSource mockLocalDataSource;
  late AuthRemoteDataSourceImpl remoteDataSource;

  setUp(() {
    mockHttpClient = MockHttpClient();
    mockLocalDataSource = MockAuthLocalDataSource();
    remoteDataSource = AuthRemoteDataSourceImpl(
      client: mockHttpClient,
      localDataSource: mockLocalDataSource,
    );
  });

  const tUserJson = {
    'id': '123',
    'email': 'test@test.com',
    'name': 'Tester',
    'password': '123456'
  };

  final tUserModel = UserModel.fromJson(tUserJson);

  group('signIn', () {
    const tEmail = 'test@test.com';
    const tPassword = '123456';

    test('should return User when response is 200', () async {
      // arrange
      final responseJson = jsonEncode({
        'access_token': 'access',
        'refresh_token': 'refresh',
        'expires_in': 3600,
        'user': tUserJson,
      });

      when(() => mockHttpClient.post(
            Uri.parse('${AuthConstants.auth}/login'),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          )).thenAnswer((_) async => http.Response(responseJson, 200));

      when(() => mockLocalDataSource.saveTokens(
            accessToken: any(named: 'accessToken'),
            refreshToken: any(named: 'refreshToken'),
            expiryTime: any(named: 'expiryTime'),
          )).thenAnswer((_) async {});

      when(() => mockLocalDataSource.saveCachedUser(any()))
          .thenAnswer((_) async {});

      // act
      final result = await remoteDataSource.signIn(
        UserModel(
          id: '123',
          email: tEmail,
          name: 'Tester',
          password: tPassword,
        ),
      );


      // assert
      expect(result, isA<UserModel>());
      expect(result.email, equals(tEmail));
      verify(() => mockLocalDataSource.saveTokens(
            accessToken: 'access',
            refreshToken: 'refresh',
            expiryTime: any(named: 'expiryTime'),
          )).called(1);
    });

    test('should throw BadRequestException when response is 400', () async {
      // arrange
      final responseJson = jsonEncode({'error': 'Bad request'});
      when(() => mockHttpClient.post(any(),
              headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer((_) async => http.Response(responseJson, 400));

      // act
      final call = remoteDataSource.signIn;

      // assert
      expect(
        () => call(tUserModel),
        throwsA(isA<BadRequestException>()),
      );
    });
  });

  group('signUp', () {
    test('should return User on 201 response', () async {
      final responseJson = jsonEncode({
        'access_token': 'access',
        'refresh_token': 'refresh',
        'expires_in': 3600,
        'user': tUserJson,
      });

      when(() => mockHttpClient.post(any(),
              headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer((_) async => http.Response(responseJson, 201));

      when(() => mockLocalDataSource.saveTokens(
            accessToken: any(named: 'accessToken'),
            refreshToken: any(named: 'refreshToken'),
            expiryTime: any(named: 'expiryTime'),
          )).thenAnswer((_) async {});
      when(() => mockLocalDataSource.saveCachedUser(any()))
          .thenAnswer((_) async {});

      final result = await remoteDataSource.signUp(tUserModel);

      expect(result, isA<UserModel>());
      expect(result.email, tUserJson['email']);
    });

    test('should throw ConflictException on 409 response', () async {
      final responseJson = jsonEncode({'error': 'User already exists'});
      when(() => mockHttpClient.post(any(),
              headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer((_) async => http.Response(responseJson, 409));

      expect(() => remoteDataSource.signUp(tUserModel),
          throwsA(isA<ConflictException>()));
    });
  });

  group('signOut', () {
    test('should delete tokens and cached user on 200', () async {
      final responseJson = jsonEncode({'success': true});
      when(() => mockLocalDataSource.getRefreshToken())
          .thenAnswer((_) async => 'refresh');
      when(() => mockLocalDataSource.getAccessToken())
          .thenAnswer((_) async => 'access');

      when(() => mockHttpClient.post(any(),
              headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer((_) async => http.Response(responseJson, 200));

      when(() => mockLocalDataSource.deleteTokens()).thenAnswer((_) async {});
      when(() => mockLocalDataSource.deleteCachedUser())
          .thenAnswer((_) async {});

      await remoteDataSource.signOut();

      verify(() => mockLocalDataSource.deleteTokens()).called(1);
      verify(() => mockLocalDataSource.deleteCachedUser()).called(1);
    });

    test('should throw UnauthorizedException on 401', () async {
      final responseJson = jsonEncode({'error': 'Unauthorized'});
      when(() => mockLocalDataSource.getRefreshToken())
          .thenAnswer((_) async => 'refresh');
      when(() => mockLocalDataSource.getAccessToken())
          .thenAnswer((_) async => 'access');

      when(() => mockHttpClient.post(any(),
              headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer((_) async => http.Response(responseJson, 401));

      expect(() => remoteDataSource.signOut(),
          throwsA(isA<UnAuthorizedException>()));
    });
  });

  group('signInWithToken', () {
    test('should return User from cache if exists', () async {
      when(() => mockLocalDataSource.getCachedUser())
          .thenAnswer((_) async => tUserJson);

      final result = await remoteDataSource.signInWithToken();

      expect(result, isA<UserModel>());
      expect(result.email, tUserJson['email']);
    });

    test('should throw CacheException if no user found', () async {
      when(() => mockLocalDataSource.getCachedUser())
          .thenAnswer((_) async => null);

      expect(() => remoteDataSource.signInWithToken(),
          throwsA(isA<CacheException>()));
    });
  });
}
