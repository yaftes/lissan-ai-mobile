import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lissan_ai/features/auth/domain/entities/user.dart';
import 'package:lissan_ai/features/auth/domain/usecases/get_token_usecase.dart';
import 'package:lissan_ai/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:lissan_ai/features/auth/domain/usecases/sign_in_with_token_usecase.dart';
import 'package:lissan_ai/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:lissan_ai/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:lissan_ai/features/auth/presentation/bloc/auth_event.dart';
import 'package:lissan_ai/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInUsecase signInUsecase;
  final SignOutUsecase signOutUsecase;
  final SignUpUsecase signUpUsecase;
  final SignInWithTokenUsecase signInWithTokenUsecase;
  final GetTokenUsecase getTokenUsecase;

  AuthBloc({
    required this.signInUsecase,
    required this.signOutUsecase,
    required this.signUpUsecase,
    required this.getTokenUsecase,
    required this.signInWithTokenUsecase,
  }) : super(InitialState()) {
    on<AppStartedEvent>((event, emit) async {
      emit(AuthLoadingState());
      final token = await getTokenUsecase();
      if (!token) {
        emit(UnAuthenticatedState());
      } else {
        add(SignInWithTokenEvent());
      }
    });

    on<SignInEvent>((event, emit) async {
      emit(AuthLoadingState());
      final user = User(email: event.email, password: event.password);
      final result = await signInUsecase(user);

      result.fold((failure) async {
        emit(AuthErrorState(message: failure.message));
        emit(UnAuthenticatedState());
      }, (success) => emit(AuthenticatedState(success)));
    });

    on<SignInWithTokenEvent>((event, emit) async {
      emit(AuthLoadingState());
      final result = await signInWithTokenUsecase();
      result.fold(
        (failure) => emit(AuthErrorState(message: failure.message)),
        (success) => emit(AuthenticatedState(success)),
      );
    });

    on<SignUpEvent>((event, emit) async {
      emit(AuthLoadingState());
      final user = User(
        email: event.email,
        password: event.password,
        name: event.name,
      );
      final result = await signUpUsecase(user);

      result.fold((failure) async {
        emit(AuthErrorState(message: failure.message));
        emit(UnAuthenticatedState());
      }, (success) => emit(AuthenticatedState(success)));
    });

    on<SignOutEvent>((event, emit) async {
      emit(AuthLoadingState());
      final result = await signOutUsecase();
      result.fold(
        (failure) => emit(AuthErrorState(message: failure.message)),
        (success) => SignedOutState(),
      );
    });
  }
}
