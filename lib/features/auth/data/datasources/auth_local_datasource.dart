import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lissan_ai/core/utils/constants/auth_constants.dart';
import 'package:lissan_ai/core/error/exceptions.dart';

abstract class AuthLocalDataSource {
  Future<String> getToken();
  Future<void> deleteToken();
  Future<void> saveToken(String token);
}

class UserLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage storage;
  UserLocalDataSourceImpl({required this.storage});

  @override
  Future<String> getToken() async {
    try {
      final token = await storage.read(key: AuthConstants.userToken ?? '');
      if (token == null) {
        throw const CacheException(message: 'No token found');
      }
      return token;
    } catch (e) {
      throw CacheException(message: 'Failed to read token: $e');
    }
  }

  @override
  Future<void> deleteToken() async {
    try {
      await storage.delete(key: AuthConstants.userToken ?? '');
    } catch (e) {
      throw CacheException(message: 'Failed to delete token: $e');
    }
  }

  @override
  Future<void> saveToken(String token) async {
    try {
      await storage.write(key: AuthConstants.userToken!, value: token);
    } catch (e) {
      throw CacheException(message: 'Failed to save token: $e');
    }
  }
}
