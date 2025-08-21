import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lissan_ai/features/auth/domain/entities/user.dart';
import 'package:lissan_ai/features/auth/domain/usecases/login_usecase.dart';
import 'package:lissan_ai/features/auth/domain/usecases/logout_usecase.dart';
import 'package:lissan_ai/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:lissan_ai/features/auth/presentation/bloc/auth_event.dart';
import 'package:lissan_ai/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUsecase loginUsecase;
  final LogoutUsecase logoutUsecase;
  final SignUpUsecase signUpUsecase;
  AuthBloc({
    required this.loginUsecase,
    required this.logoutUsecase,
    required this.signUpUsecase,
  }) : super(InitialState()) {
    on<LoginEvent>((event, emit) async {
      emit(LoadingState());
      final user = User(email: event.email, password: event.password);
      final result = await loginUsecase(user);
      result.fold(
        (failure) => emit(ErrorState(message: failure.message)),
        (success) => emit(LoggedInState(success)),
      );
    });
    on<SignUpEvent>((event, emit) async {
      emit(LoadingState());
      final user = User(
        email: event.email,
        password: event.password,
        name: event.fullName,
      );
      final result = await loginUsecase(user);
      result.fold(
        (failure) => emit(ErrorState(message: failure.message)),
        (success) => emit(LoggedInState(success)),
      );
    });
  }
}
