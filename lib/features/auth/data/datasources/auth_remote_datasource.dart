import 'package:http/http.dart' as http;
import 'package:lissan_ai/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:lissan_ai/features/auth/domain/entities/user.dart';

abstract class AuthRemoteDataSource {

  Future<User> signUp(User user);
  Future<User> signIn(User user);
  Future<void> signOut();
  Future<User> signInWithToken(String token);
  Future<User> signInWithGoogle(String token);
  Future<User> signUpWithGoogle();
  Future<void> deleteAccount();
  Future<void> updateProfile(User user);
  Future<void> forgotPassword();
  Future<String> getToken();

  
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;
  final AuthLocalDataSource localDataSource;

  AuthRemoteDataSourceImpl({
    required this.client,
    required this.localDataSource,
  });

  @override
  Future<void> deleteAccount() {
    // TODO: implement deleteAccount
    throw UnimplementedError();
  }

  @override
  Future<void> forgotPassword() {
    // TODO: implement forgotPassword
    throw UnimplementedError();
  }

  @override
  Future<String> getToken() {
    // TODO: implement getToken
    throw UnimplementedError();
  }

  @override
  Future<User> signIn(User user) {
    // TODO: implement signIn
    throw UnimplementedError();
  }

  @override
  Future<User> signInWithGoogle(String token) {
    // TODO: implement signInWithGoogle
    throw UnimplementedError();
  }

  @override
  Future<User> signInWithToken(String token) {
    // TODO: implement signInWithToken
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }

  @override
  Future<User> signUp(User user) {
    // TODO: implement signUp
    throw UnimplementedError();
  }

  @override
  Future<User> signUpWithGoogle() {
    // TODO: implement signUpWithGoogle
    throw UnimplementedError();
  }

  @override
  Future<void> updateProfile(User user) {
    // TODO: implement updateProfile
    throw UnimplementedError();
  }
}
