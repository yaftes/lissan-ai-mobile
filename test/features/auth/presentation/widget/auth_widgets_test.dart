import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lissan_ai/core/error/failure.dart';
import 'package:lissan_ai/features/auth/domain/entities/user.dart';
import 'package:lissan_ai/features/auth/domain/repositories/auth_repository.dart';
import 'package:lissan_ai/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:lissan_ai/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:lissan_ai/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:lissan_ai/features/auth/domain/usecases/get_token_usecase.dart';
import 'package:lissan_ai/features/auth/domain/usecases/sign_in_with_token_usecase.dart';
import 'package:lissan_ai/features/auth/domain/usecases/get_user_usecase.dart';
import 'package:lissan_ai/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lissan_ai/features/auth/presentation/bloc/auth_event.dart';
import 'package:lissan_ai/features/auth/presentation/bloc/auth_state.dart';
import 'package:lissan_ai/features/auth/presentation/pages/signin_page.dart';
import 'package:lissan_ai/features/auth/presentation/pages/signup_page.dart';
import 'package:dartz/dartz.dart';

class FakeSignInUsecase implements SignInUsecase {
  @override
  Future<Either<Failure, User>> call(User user) async {
    return Right(User(email: user.email, password: user.password));
  }

  @override
  AuthRepository get repository => throw UnimplementedError();
}

class FakeSignUpUsecase implements SignUpUsecase {
  @override
  Future<Either<Failure, User>> call(User user) async {
    return Right(user);
  }

  @override
  AuthRepository get repository => throw UnimplementedError();
}

class FakeSignOutUsecase implements SignOutUsecase {
  @override
  Future<Either<Failure, Unit>> call() async => const Right(unit);

  @override
  AuthRepository get repository => throw UnimplementedError();
}

class FakeGetTokenUsecase implements GetTokenUsecase {
  @override
  Future<bool> call() async => true;

  @override
  AuthRepository get repository => throw UnimplementedError();
}

class FakeSignInWithTokenUsecase implements SignInWithTokenUsecase {
  @override
  Future<Either<Failure, User>> call() async =>
      Right(User(email: 'token@test.com', password: '123456'));

  @override
  AuthRepository get repository => throw UnimplementedError();
}

class FakeGetUserUsecase implements GetUserUsecase {
  @override
  Future<Either<Failure, User>> call() async =>
      Right(User(email: 'user@test.com', password: '123456'));

  @override
  AuthRepository get repository => throw UnimplementedError();
}

void main() {
  AuthBloc createBloc() {
    return AuthBloc(
      signInUsecase: FakeSignInUsecase(),
      signOutUsecase: FakeSignOutUsecase(),
      signUpUsecase: FakeSignUpUsecase(),
      getTokenUsecase: FakeGetTokenUsecase(),
      signInWithTokenUsecase: FakeSignInWithTokenUsecase(),
      getUserUsecase: FakeGetUserUsecase(),
    );
  }

  group('Auth Pages Tests', () {
    group('SignInPage Tests', () {
      testWidgets('should display Login title and fields', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider<AuthBloc>(
              create: (_) => createBloc(),
              child: const SignInPage(),
            ),
          ),
        );

        expect(find.text('Login'), findsOneWidget);
        expect(find.byType(TextFormField), findsNWidgets(2));
        expect(find.text('Sign In'), findsOneWidget);
      });

      testWidgets(
        'should show loading indicator when state is AuthLoadingState',
        (tester) async {
          final bloc = createBloc();
          bloc.emit(AuthLoadingState());

          await tester.pumpWidget(
            MaterialApp(
              home: BlocProvider<AuthBloc>(
                create: (_) => bloc,
                child: const SignInPage(),
              ),
            ),
          );
          await tester.pump();

          expect(find.byType(CircularProgressIndicator), findsOneWidget);
        },
      );

      testWidgets('should type into email and password and press Sign In', (
        tester,
      ) async {
        final bloc = createBloc();
        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider<AuthBloc>(
              create: (_) => bloc,
              child: const SignInPage(),
            ),
          ),
        );

        await tester.enterText(
          find.byType(TextFormField).at(0),
          'test@email.com',
        );
        await tester.enterText(find.byType(TextFormField).at(1), 'password123');
        await tester.tap(find.text('Sign In'));
        await tester.pump();

        expect(find.text('test@email.com'), findsOneWidget);
        expect(find.text('password123'), findsOneWidget);
      });
    });

    group('SignUpPage Tests', () {
      testWidgets('should display title and form fields', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider<AuthBloc>(
              create: (_) => createBloc(),
              child: const SignUpPage(),
            ),
          ),
        );

        expect(find.text('Join the Adventure!'), findsOneWidget);
        expect(find.byType(TextFormField), findsNWidgets(4));
        expect(find.text('Create Account'), findsOneWidget);
      });

      testWidgets('should show error when passwords do not match', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider<AuthBloc>(
              create: (_) => createBloc(),
              child: const SignUpPage(),
            ),
          ),
        );

        await tester.enterText(find.byType(TextFormField).at(2), '123456');
        await tester.enterText(find.byType(TextFormField).at(3), 'abcdef');
        await tester.pump();

        expect(find.text('Passwords do not match'), findsOneWidget);
      });

      testWidgets('should show error bottom sheet if terms not accepted', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider<AuthBloc>(
              create: (_) => createBloc(),
              child: const SignUpPage(),
            ),
          ),
        );

        await tester.tap(find.text('Create Account'));
        await tester.pumpAndSettle();

        expect(
          find.text('You must accept the Terms and Privacy Policy'),
          findsOneWidget,
        );
      });

      testWidgets(
        'should show loading indicator when state is AuthLoadingState',
        (tester) async {
          final bloc = createBloc();
          bloc.emit(AuthLoadingState());

          await tester.pumpWidget(
            MaterialApp(
              home: BlocProvider<AuthBloc>(
                create: (_) => bloc,
                child: const SignUpPage(),
              ),
            ),
          );
          await tester.pump();

          expect(find.byType(CircularProgressIndicator), findsOneWidget);
        },
      );
    });
  });
}
