import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:lissan_ai/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lissan_ai/features/auth/presentation/bloc/auth_state.dart';
import 'package:lissan_ai/features/auth/presentation/pages/signin_page.dart';

class MockAuthBloc extends Mock implements AuthBloc {}

void main() {
  late MockAuthBloc mockAuthBloc;

  setUp(() {
    mockAuthBloc = MockAuthBloc();

    // Provide initial state and stream
    when(() => mockAuthBloc.state).thenReturn(InitialState());
    when(() => mockAuthBloc.stream).thenAnswer((_) => const Stream.empty());
  });

  Widget makeTestable(Widget child) {
    return MaterialApp(
      home: BlocProvider<AuthBloc>.value(
        value: mockAuthBloc,
        child: child,
      ),
    );
  }

  testWidgets('SignInPage shows Sign In button', (tester) async {
    // Render the SignInPage
    await tester.pumpWidget(makeTestable(const SignInPage()));

    // Check if "Sign In" button exists
    expect(find.text('Sign In'), findsOneWidget);
  });

  testWidgets('SignInPage shows Create Account link', (tester) async {
    await tester.pumpWidget(makeTestable(const SignInPage()));

    expect(find.text('Create Account'), findsOneWidget);
  });

  testWidgets('SignInPage shows Email and Password fields', (tester) async {
    await tester.pumpWidget(makeTestable(const SignInPage()));

    expect(find.widgetWithText(TextFormField, 'Enter your email'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Enter your password'), findsOneWidget);
  });
}
