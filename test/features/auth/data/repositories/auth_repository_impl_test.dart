import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lissan_ai/core/error/exceptions.dart';
import 'package:lissan_ai/core/error/failure.dart';
import 'package:lissan_ai/core/network/network_info.dart';
import 'package:lissan_ai/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:lissan_ai/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:lissan_ai/features/auth/data/models/user_model.dart';
import 'package:lissan_ai/features/auth/domain/entities/user.dart';
import 'package:lissan_ai/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

class MockRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockLocalDataSource extends Mock implements AuthLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}
class FakeUser extends Fake implements User {}

void main() {
  late AuthRepositoryImpl repository;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  final tUser = UserModel(id: '1', email: 'test@test.com');
  final tUserEntity = User(id: '1', email: 'test@test.com');
  setUpAll(() {
    registerFallbackValue(FakeUser());
  });
  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = AuthRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('signIn', () {
    test('should return User when remote call succeeds', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.signIn(any()))
          .thenAnswer((_) async => tUser);

      final result = await repository.signIn(tUserEntity);

      expect(result, Right(tUser));
      verify(() => mockRemoteDataSource.signIn(tUserEntity)).called(1);
    });

    test('should return ServerFailure when remote throws ServerException', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.signIn(any()))
          .thenThrow(const ServerException(message: 'server error'));

      final result = await repository.signIn(tUserEntity);

      expect(result, equals(const Left(ServerFailure(message: 'server error'))));
    });

    test('should return NetworkFailure when not connected', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      final result = await repository.signIn(tUserEntity);

      expect(result, const Left(NetworkFailure(message: 'No internet connection')));
      verifyNever(() => mockRemoteDataSource.signIn(any()));
    });
  });

  group('signOut', () {
    test('should return unit when successful', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.signOut()).thenAnswer((_) async {});

      final result = await repository.signOut();

      expect(result, const Right(unit));
      verify(() => mockRemoteDataSource.signOut()).called(1);
    });

    test('should return NetworkFailure when offline', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      final result = await repository.signOut();

      expect(result, const Left(NetworkFailure(message: 'No internet connection')));
      verifyNever(() => mockRemoteDataSource.signOut());
    });
  });

  group('signUp', () {
    test('should return User when successful', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.signUp(any()))
          .thenAnswer((_) async => tUser);

      final result = await repository.signUp(tUserEntity);

      expect(result, Right(tUser));
      verify(() => mockRemoteDataSource.signUp(tUserEntity)).called(1);
    });
  });

  group('signInWithToken', () {
    test('should return User when successful', () async {
      when(() => mockRemoteDataSource.signInWithToken())
          .thenAnswer((_) async => tUser);

      final result = await repository.signInWithToken();

      expect(result, Right(tUser));
      verify(() => mockRemoteDataSource.signInWithToken()).called(1);
    });

    test('should return CacheFailure when CacheException thrown', () async {
      when(() => mockRemoteDataSource.signInWithToken())
          .thenThrow(const CacheException(message: 'cache error'));

      final result = await repository.signInWithToken();

      expect(result, equals(const Left(CacheFailure(message: 'cache error'))));
    });
  });

  group('isTokenValid', () {
    test('should return true when accessToken is not expired', () async {
      when(() => mockLocalDataSource.getAccessToken())
          .thenAnswer((_) async => 'token');
      when(() => mockLocalDataSource.getExpiryTime())
          .thenAnswer((_) async => DateTime.now().millisecondsSinceEpoch + 10000);

      final result = await repository.isTokenValid();

      expect(result, true);
    });

    test('should return false when no accessToken', () async {
      when(() => mockLocalDataSource.getAccessToken())
          .thenAnswer((_) async => null);

      final result = await repository.isTokenValid();

      expect(result, false);
    });
  });

  group('getUser', () {
    test('should return cached user when found', () async {
      when(() => mockLocalDataSource.getCachedUser())
          .thenAnswer((_) async => {'id': '1', 'email': 'test@test.com'});

      final result = await repository.getUser();

      expect(result, Right(tUser));
      verify(() => mockLocalDataSource.getCachedUser()).called(1);
    });

    test('should return CacheFailure when no user found', () async {
      when(() => mockLocalDataSource.getCachedUser())
          .thenAnswer((_) async => null);

      final result = await repository.getUser();

      expect(result, const Left(CacheFailure(message: 'No cached user found')));
    });
  });
}
