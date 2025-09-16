import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lissan_ai/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lissan_ai/features/auth/presentation/bloc/auth_state.dart';
import 'package:lissan_ai/features/auth/presentation/pages/signin_page.dart';

void main() {
  group('SignInPage Widget Tests', () {
    testWidgets('should display Login title and fields', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthBloc>(
            create: (_) => AuthBloc(),
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
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider<AuthBloc>(
              create: (_) => AuthBloc()..emit(AuthLoadingState()),
              child: const SignInPage(),
            ),
          ),
        );

        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      },
    );

    testWidgets('should type into email and password and press Sign In', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthBloc>(
            create: (_) => AuthBloc(),
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
}
