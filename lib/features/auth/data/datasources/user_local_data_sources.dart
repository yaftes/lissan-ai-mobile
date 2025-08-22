import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lissan_ai/core/error/exceptions.dart';
import 'package:lissan_ai/features/auth/data/model/user_model.dart';

abstract class UserLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<String> getToken();
  Future<UserModel> getCachedUser();
  Future<void> clearCache();
  
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final FlutterSecureStorage storage;

  UserLocalDataSourceImpl({required this.storage});

  static const String tokenKey = 'token';
  static const String userKey = 'user';

  @override
  Future<String> getToken() async {
    final String token = await storage.read(key: tokenKey) as String;
    return token;
  }

  @override
  Future<void> clearCache() async {
    await storage.delete(key: 'token');
    // await storage.delete(key: 'user');
  }
  
  @override
  Future<UserModel> getCachedUser() async {
    final jsonString = await storage.read(key: userKey);
    if (jsonString == null) throw const CacheException(message: 'No user cached');
    final Map<String, dynamic> userMap = jsonDecode(jsonString);
    return UserModel.fromJson(userMap);
  }
  
  @override
  Future<void> cacheUser(UserModel user) async {
    if (user.password != null) {
      await storage.write(key: tokenKey, value: user.password);
    }
    await storage.write(key: userKey, value: json.encode(user.toJson()));
  }

}
