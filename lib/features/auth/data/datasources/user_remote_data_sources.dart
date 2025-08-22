import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:lissan_ai/core/error/exceptions.dart';
import 'package:lissan_ai/features/auth/data/model/user_model.dart';
import 'package:lissan_ai/features/auth/domain/entities/user.dart';

abstract class UserRemoteDataSource {
  Future<User> loginUser({required String email, required String password});

  Future<User?> registerUser({required String name, required String email, required String password,});

  Future<void> forgotPassword({required String email});

  Future<Unit> logoutUser({required String token});

}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  UserRemoteDataSourceImpl({required this.baseUrl, required this.client});

  @override
  Future<User> loginUser({required String email, required String password}) async {
    final response = await client.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return UserModel.fromJson(decoded);
    } else if (response.statusCode == 401) {
      throw const AuthException(message: 'Invalid email or password.');
    } else {
      throw ServerException(message: response.body);
    }
  }

  @override
  Future<Unit> logoutUser({required String token}) async {
    final response = await client.post(
      Uri.parse('$baseUrl/logout'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'token': token}),
    );
    if (response.statusCode == 200) {
      return unit;
    } else {
      throw ServerException(message: response.body);
    }
  }

  @override
  Future<User> registerUser({required String name, required String email, required String password}) async {
    final response = await client.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    if (response.statusCode == 201) {
      final decoded = jsonDecode(response.body);
      return UserModel.fromJson(decoded);
    } else {
      throw ServerException(message: response.body);
    }
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    final response = await client.post(
      Uri.parse('$baseUrl/forgot-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode == 200) {
      // Password reset email sent
    } else {
      throw ServerException(message: response.body);
    }
  }
  
}
