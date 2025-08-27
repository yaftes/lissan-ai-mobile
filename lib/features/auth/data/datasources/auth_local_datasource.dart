import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lissan_ai/core/utils/constants/auth_constants.dart';
import 'package:lissan_ai/core/error/exceptions.dart';

abstract class AuthLocalDataSource {
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<int?> getExpiryTime();
  Future<void> deleteTokens();

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required int expiryTime,
  });
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage storage;
  AuthLocalDataSourceImpl({required this.storage});

  @override
  Future<String?> getAccessToken() async {
    try {
      return await storage.read(key: AuthConstants.accessToken);
    } catch (e) {
      throw CacheException(message: 'Failed to read access token: $e');
    }
  }

  @override
  Future<String?> getRefreshToken() async {
    try {
      return await storage.read(key: AuthConstants.refreshToken);
    } catch (e) {
      throw CacheException(message: 'Failed to read refresh token: $e');
    }
  }

  @override
  Future<int?> getExpiryTime() async {
    try {
      final expiryStr = await storage.read(key: AuthConstants.expiryTime);
      return expiryStr != null ? int.tryParse(expiryStr) : null;
    } catch (e) {
      throw CacheException(message: 'Failed to read expiry time: $e');
    }
  }

  @override
  Future<void> deleteTokens() async {
    try {
      await storage.delete(key: AuthConstants.accessToken);
      await storage.delete(key: AuthConstants.refreshToken);
      await storage.delete(key: AuthConstants.expiryTime);
    } catch (e) {
      throw CacheException(message: 'Failed to delete tokens: $e');
    }
  }

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required int expiryTime,
  }) async {
    try {
      await storage.write(key: AuthConstants.accessToken, value: accessToken);
      await storage.write(key: AuthConstants.refreshToken, value: refreshToken);
      await storage.write(
        key: AuthConstants.expiryTime,
        value: expiryTime.toString(),
      );
    } catch (e) {
      throw CacheException(message: 'Failed to save tokens: $e');
    }
  }
}
