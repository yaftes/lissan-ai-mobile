import 'package:flutter/material.dart';
import 'package:lissan_ai/features/auth/presentation/pages/home_page.dart';
import 'package:lissan_ai/features/auth/presentation/pages/onboarding_page.dart';
import 'package:lissan_ai/features/auth/presentation/pages/signin_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,

      home: OnboardingPage(),
    );
  }
}
