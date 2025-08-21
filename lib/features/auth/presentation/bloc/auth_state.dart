import 'package:lissan_ai/features/auth/domain/entities/user.dart';

abstract class AuthState {}

class InitialState extends AuthState {}

class LoadingState extends AuthState {}

class ErrorState extends AuthState {
  final String message;
  ErrorState({required this.message});
}

class LoggedInState extends AuthState {
  final User user;
  LoggedInState(this.user);
}

class LoggedOutState extends AuthState {}

class SignedUpState extends AuthState {}
