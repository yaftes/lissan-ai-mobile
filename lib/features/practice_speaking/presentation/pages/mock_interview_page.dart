import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'package:lissan_ai/features/practice_speaking/presentation/widgets/circle_avatar_widget.dart';
import 'package:lissan_ai/features/practice_speaking/presentation/widgets/menu_widget.dart';
import 'package:lissan_ai/features/practice_speaking/presentation/widgets/mock_interview_header.dart';
import 'package:lissan_ai/features/practice_speaking/presentation/widgets/progress_bar.dart';
import 'package:lissan_ai/features/practice_speaking/presentation/widgets/question_card.dart';
import 'package:lissan_ai/features/practice_speaking/presentation/widgets/record_button.dart';
import 'package:lissan_ai/features/practice_speaking/presentation/widgets/navigation_buttons.dart';

class MockInterviewPage extends StatefulWidget {
  const MockInterviewPage({super.key});

  @override
  State<MockInterviewPage> createState() => _MockInterviewPageState();
}

class _MockInterviewPageState extends State<MockInterviewPage> {
  int _currentPage = 1;
  final int _maxPage = 5;
  final String question = 'Tell me about yourself and your background.';
  late FlutterTts flutterTts;

  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts();
    _setTtsSettings();
  }

  Future<void> _setTtsSettings() async {
    await flutterTts.setLanguage('en-US');
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setPitch(1.0);
  }

  Future<void> _speak(String text) async {
    await flutterTts.speak(text);
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Lissan Ai',
          style: GoogleFonts.inter(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      drawer: const MenuWidget(),
      body: SingleChildScrollView(
        child: Column(
          spacing: 8,
          children: [
            const Center(
              child: CircleAvatarWidget(
                radius: 80,
                width: 140,
                height: 140,
                padd: 12,
              ),
            ),
            const MockInterviewHeader(),
            ProgressBar(currentPage: _currentPage, maxPage: _maxPage),
            QuestionCard(
              question: question,
              onSpeak: () => _speak(question),
            ),
            const RecordButton(),
            NavigationButtons(
              currentPage: _currentPage,
              maxPage: _maxPage,
              onPrevious: () {
                if (_currentPage > 1) {
                  setState(() => _currentPage--);
                }
              },
              onNext: () {
                if (_currentPage < _maxPage) {
                  setState(() => _currentPage++);
                  _speak(question); // autospeak
                }
              },
            ),
            const Text(
              '🔥 Keep practicing to maintain your streak!',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
