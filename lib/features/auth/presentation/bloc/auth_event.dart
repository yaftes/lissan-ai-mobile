abstract class AuthEvent {}

class AppStartedEvent extends AuthEvent {}

class SignInEvent extends AuthEvent {
  final String email;
  final String password;
  SignInEvent({required this.email, required this.password});
}

class SignInWithTokenEvent extends AuthEvent {}

class SignUpEvent extends AuthEvent {
  final String fullName;
  final String email;
  final String password;
  SignUpEvent({
    required this.fullName,
    required this.email,
    required this.password,
  });
}

class SignOutEvent extends AuthEvent {}
