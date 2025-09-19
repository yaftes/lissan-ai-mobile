import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';

import 'package:lissan_ai/features/auth/presentation/pages/signup_page.dart';
import 'package:lissan_ai/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lissan_ai/features/auth/presentation/bloc/auth_event.dart';
import 'package:lissan_ai/features/auth/presentation/bloc/auth_state.dart';

class MockAuthBloc extends Mock implements AuthBloc {}

class FakeAuthEvent extends Fake implements AuthEvent {}

class FakeAuthState extends Fake implements AuthState {}

Widget makeTestable(Widget child, AuthBloc bloc) {
  return MaterialApp(
    home: BlocProvider<AuthBloc>.value(
      value: bloc,
      child: child,
    ),
  );
}

void main() {
  late MockAuthBloc mockAuthBloc;

  setUp(() {
    mockAuthBloc = MockAuthBloc();
    when(() => mockAuthBloc.state).thenReturn(InitialState());
    when(() => mockAuthBloc.stream).thenAnswer((_) => const Stream.empty());
  });

  testWidgets('SignUpPage should render the "Create Account" button',
      (WidgetTester tester) async {
    await tester.pumpWidget(makeTestable(const SignUpPage(), mockAuthBloc));

    expect(find.text('Create Account'), findsOneWidget);
  });
}
