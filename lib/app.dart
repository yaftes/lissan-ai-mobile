import 'package:flutter/material.dart';
import 'package:lissan_ai/features/auth/presentation/pages/auth_wrapper_page.dart';
import 'package:lissan_ai/features/auth/presentation/pages/dashboard_page.dart';
import 'package:lissan_ai/features/auth/presentation/pages/onboarding_page.dart';
import 'package:lissan_ai/features/auth/presentation/pages/signin_page.dart';
import 'package:lissan_ai/features/auth/presentation/pages/signup_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const AuthWrapperPage(),
        '/sign-in': (context) => const SignInPage(),
        '/sign-up': (context) => const SignUpPage(),
        '/dashboard': (context) => const Dashboard(),
        '/onboarding': (context) => const OnboardingPage(),
      },
      initialRoute: '/',
    );
  }
}
