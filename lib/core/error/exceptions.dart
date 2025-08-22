import 'package:equatable/equatable.dart';

/// Base exception class
abstract class AppException extends Equatable implements Exception {
  final String message;
  const AppException({required this.message});

  @override
  List<Object?> get props => [message];

  @override
  String toString() => message;
}

/// Thrown when a server error occurs (5xx, invalid response, etc.)
class ServerException extends AppException {
  const ServerException({required super.message});
}

/// Thrown when there is no internet connection or request timeout
class NetworkException extends AppException {
  const NetworkException({required super.message});
}

/// Thrown when a cache operation (read/write/delete) fails
class CacheException extends AppException {
  const CacheException({required super.message});
}

/// Thrown when authentication fails (invalid token, expired session, etc.)
class AuthException extends AppException {
  const AuthException({required super.message});
}
