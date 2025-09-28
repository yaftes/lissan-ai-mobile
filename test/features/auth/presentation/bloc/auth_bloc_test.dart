import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lissan_ai/core/error/failure.dart';
import 'package:mocktail/mocktail.dart';
import 'package:lissan_ai/features/auth/domain/entities/user.dart';
import 'package:lissan_ai/features/auth/domain/usecases/get_token_usecase.dart';
import 'package:lissan_ai/features/auth/domain/usecases/get_user_usecase.dart';
import 'package:lissan_ai/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:lissan_ai/features/auth/domain/usecases/sign_in_with_token_usecase.dart';
import 'package:lissan_ai/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:lissan_ai/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:lissan_ai/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lissan_ai/features/auth/presentation/bloc/auth_event.dart';
import 'package:lissan_ai/features/auth/presentation/bloc/auth_state.dart';

class MockSignInUsecase extends Mock implements SignInUsecase {}
class MockSignOutUsecase extends Mock implements SignOutUsecase {}
class MockSignUpUsecase extends Mock implements SignUpUsecase {}
class MockSignInWithTokenUsecase extends Mock implements SignInWithTokenUsecase {}
class MockGetTokenUsecase extends Mock implements GetTokenUsecase {}
class MockGetUserUsecase extends Mock implements GetUserUsecase {}

class FakeUser extends Fake implements User {}

void main() {
  late AuthBloc authBloc;
  late MockSignInUsecase mockSignInUsecase;
  late MockSignOutUsecase mockSignOutUsecase;
  late MockSignUpUsecase mockSignUpUsecase;
  late MockSignInWithTokenUsecase mockSignInWithTokenUsecase;
  late MockGetTokenUsecase mockGetTokenUsecase;
  late MockGetUserUsecase mockGetUserUsecase;

  setUpAll(() {
    registerFallbackValue(FakeUser());
  });

  setUp(() {
    mockSignInUsecase = MockSignInUsecase();
    mockSignOutUsecase = MockSignOutUsecase();
    mockSignUpUsecase = MockSignUpUsecase();
    mockSignInWithTokenUsecase = MockSignInWithTokenUsecase();
    mockGetTokenUsecase = MockGetTokenUsecase();
    mockGetUserUsecase = MockGetUserUsecase();

    authBloc = AuthBloc(
      signInUsecase: mockSignInUsecase,
      signOutUsecase: mockSignOutUsecase,
      signUpUsecase: mockSignUpUsecase,
      getTokenUsecase: mockGetTokenUsecase,
      signInWithTokenUsecase: mockSignInWithTokenUsecase,
      getUserUsecase: mockGetUserUsecase,
    );
  });

  final tUser = User(email: 'test@test.com', password: '123456');
  // final tUserWithName = User(name: 'Test', email: 'test@test.com', password: '123456');

  group('AuthBloc', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoadingState, UnAuthenticatedState] when AppStartedEvent has no token',
      build: () {
        when(() => mockGetTokenUsecase()).thenAnswer((_) async => false);
        return authBloc;
      },
      act: (bloc) => bloc.add(AppStartedEvent()),
      expect: () => [
        AuthLoadingState(),
        UnAuthenticatedState(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoadingState, AuthenticatedState] when AppStartedEvent has a valid token and signInWithToken succeeds',
      build: () {
        when(() => mockGetTokenUsecase()).thenAnswer((_) async => true);
        when(() => mockSignInWithTokenUsecase()).thenAnswer((_) async => Right(tUser));
        return authBloc;
      },
      act: (bloc) => bloc.add(AppStartedEvent()),
      expect: () => [
        AuthLoadingState(),
        AuthLoadingState(), // second loading for SignInWithTokenEvent
        AuthenticatedState(tUser),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoadingState, AuthErrorState, UnAuthenticatedState] when SignInWithTokenEvent fails',
      build: () {
        when(() => mockSignInWithTokenUsecase()).thenAnswer(
          (_) async => const Left(ServerFailure(message: 'Token expired')),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(SignInWithTokenEvent()),
      expect: () => [
        AuthLoadingState(),
        isA<AuthErrorState>(),
        UnAuthenticatedState(),
      ],
    );


  });
}
