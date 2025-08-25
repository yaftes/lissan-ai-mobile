import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lissan_ai/core/utils/constants/auth_constants.dart';
import 'package:lissan_ai/core/error/exceptions.dart';

abstract class AuthLocalDataSource {
  Future<String> getAccessToken();
  Future<String> getRefreshToken();
  Future<void> deleteTokens();
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  });
}

class UserLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage storage;
  UserLocalDataSourceImpl({required this.storage});

  @override
  Future<String> getAccessToken() async {
    try {
      final token = await storage.read(key: AuthConstants.accessToken);
      if (token == null) {
        throw const CacheException(message: 'No access token found');
      }
      return token;
    } catch (e) {
      throw CacheException(message: 'Failed to read access token: $e');
    }
  }

  @override
  Future<String> getRefreshToken() async {
    try {
      final token = await storage.read(key: AuthConstants.refreshToken);
      if (token == null) {
        throw const CacheException(message: 'No refresh token found');
      }
      return token;
    } catch (e) {
      throw CacheException(message: 'Failed to read refresh token: $e');
    }
  }

  @override
  Future<void> deleteTokens() async {
    try {
      await storage.delete(key: AuthConstants.accessToken);
      await storage.delete(key: AuthConstants.refreshToken);
    } catch (e) {
      throw CacheException(message: 'Failed to delete tokens: $e');
    }
  }

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    try {
      await storage.write(key: AuthConstants.accessToken, value: accessToken);
      await storage.write(key: AuthConstants.refreshToken, value: refreshToken);
    } catch (e) {
      throw CacheException(message: 'Failed to save tokens: $e');
    }
  }
}
