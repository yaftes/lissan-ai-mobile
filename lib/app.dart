import 'package:flutter/material.dart';
import 'package:lissan_ai/features/practice_speaking/presentation/pages/mock_interview_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MockInterviewPage(),
    );
  }
}
