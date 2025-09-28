import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lissan_ai/core/error/exceptions.dart';
import 'package:lissan_ai/core/utils/constants/auth_constants.dart';
import 'package:lissan_ai/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSecureStorage extends Mock implements FlutterSecureStorage {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late AuthLocalDataSourceImpl dataSource;
  late MockSecureStorage mockSecureStorage;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSecureStorage = MockSecureStorage();
    mockSharedPreferences = MockSharedPreferences();
    dataSource = AuthLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
      storage: mockSecureStorage,
    );
  });

  group('Token Methods', () {
    const tAccessToken = 'access_token_123';
    const tRefreshToken = 'refresh_token_456';
    const tExpiryTime = 1234567890;

    test('should return access token when present in storage', () async {
      when(() => mockSecureStorage.read(key: AuthConstants.accessToken))
          .thenAnswer((_) async => tAccessToken);

      final result = await dataSource.getAccessToken();

      expect(result, tAccessToken);
      verify(() => mockSecureStorage.read(key: AuthConstants.accessToken))
          .called(1);
    });

    test('should return refresh token when present in storage', () async {
      when(() => mockSecureStorage.read(key: AuthConstants.refreshToken))
          .thenAnswer((_) async => tRefreshToken);

      final result = await dataSource.getRefreshToken();

      expect(result, tRefreshToken);
      verify(() => mockSecureStorage.read(key: AuthConstants.refreshToken))
          .called(1);
    });

    test('should return expiry time as int when present in storage', () async {
      when(() => mockSecureStorage.read(key: AuthConstants.expiryTime))
          .thenAnswer((_) async => tExpiryTime.toString());

      final result = await dataSource.getExpiryTime();

      expect(result, tExpiryTime);
      verify(() => mockSecureStorage.read(key: AuthConstants.expiryTime))
          .called(1);
    });

    test('should delete tokens from storage', () async {
      when(() => mockSecureStorage.delete(key: any(named: 'key')))
          .thenAnswer((_) async {});

      await dataSource.deleteTokens();

      verify(() => mockSecureStorage.delete(key: AuthConstants.accessToken))
          .called(1);
      verify(() => mockSecureStorage.delete(key: AuthConstants.refreshToken))
          .called(1);
      verify(() => mockSecureStorage.delete(key: AuthConstants.expiryTime))
          .called(1);
    });

    test('should save tokens into storage', () async {
      when(() => mockSecureStorage.write(key: any(named: 'key'), value: any(named: 'value')))
          .thenAnswer((_) async {});

      await dataSource.saveTokens(
        accessToken: tAccessToken,
        refreshToken: tRefreshToken,
        expiryTime: tExpiryTime,
      );

      verify(() => mockSecureStorage.write(
          key: AuthConstants.accessToken, value: tAccessToken)).called(1);
      verify(() => mockSecureStorage.write(
          key: AuthConstants.refreshToken, value: tRefreshToken)).called(1);
      verify(() => mockSecureStorage.write(
          key: AuthConstants.expiryTime, value: tExpiryTime.toString())).called(1);
    });
  });

  group('User Caching', () {
    const tUserJson = {'id': '1', 'email': 'test@test.com'};
    final tJsonString = jsonEncode(tUserJson);

    test('should save cached user into SharedPreferences', () async {
      when(() => mockSharedPreferences.setString(
              AuthConstants.cachedUser, tJsonString))
          .thenAnswer((_) async => true);

      await dataSource.saveCachedUser(tUserJson);

      verify(() => mockSharedPreferences.setString(
          AuthConstants.cachedUser, tJsonString)).called(1);
    });

    test('should return cached user when present in SharedPreferences', () async {
      when(() => mockSharedPreferences.getString(AuthConstants.cachedUser))
          .thenReturn(tJsonString);

      final result = await dataSource.getCachedUser();

      expect(result, tUserJson);
      verify(() => mockSharedPreferences.getString(AuthConstants.cachedUser))
          .called(1);
    });

    test('should return null when cached user not found', () async {
      when(() => mockSharedPreferences.getString(AuthConstants.cachedUser))
          .thenReturn(null);

      final result = await dataSource.getCachedUser();

      expect(result, null);
    });

    test('should delete cached user from SharedPreferences', () async {
      when(() => mockSharedPreferences.remove(AuthConstants.cachedUser))
          .thenAnswer((_) async => true);

      await dataSource.deleteCachedUser();

      verify(() => mockSharedPreferences.remove(AuthConstants.cachedUser))
          .called(1);
    });
  });

  group('Exception Handling', () {
    test('should throw CacheException when storage.read throws', () async {
      when(() => mockSecureStorage.read(key: AuthConstants.accessToken))
          .thenThrow(Exception('storage error'));

      expect(() => dataSource.getAccessToken(),
          throwsA(isA<CacheException>()));
    });

    test('should throw CacheException when sharedPreferences throws', () async {
      when(() => mockSharedPreferences.getString(AuthConstants.cachedUser))
          .thenThrow(Exception('prefs error'));

      expect(() => dataSource.getCachedUser(),
          throwsA(isA<CacheException>()));
    });
  });
}
