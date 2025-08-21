abstract class AuthEvent {}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;
  LoginEvent({required this.email, required this.password});
}

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
