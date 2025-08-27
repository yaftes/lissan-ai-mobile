import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'package:lissan_ai/features/practice_speaking/presentation/widgets/circle_avatar_widget.dart';
import 'package:lissan_ai/features/practice_speaking/presentation/widgets/menu_widget.dart';
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
          children: [
            const SizedBox(height: 16),
            const Center(
              child: CircleAvatarWidget(
                radius: 150,
                padd: 12,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '🎯 Mock Interview Practice',
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: 
                  [Color(0xFFDDFFEF), Color(0xFFE2EFFF)]),
                  borderRadius: const BorderRadius.all(Radius.circular(8),),
                  border: Border.all(color: const Color(0xFFA7F3D0), width: 1.5 ),
                ),
                child: Text('Question $_currentPage of 5. Let\'s practice this together! 💪'),
              ),

            _buildProgressBar(),
            const SizedBox(height: 8),
            QuestionCard(
              question: question,
              onSpeak: () => _speak(question),
            ),
            const SpeechPage(),
            const SizedBox(height: 16),
            NavigationButtons(
              currentPage: _currentPage,
              maxPage: _maxPage,
              onPrevious: () {
                if (_currentPage > 1) setState(() => _currentPage--);
              },
              onNext: () {
                if (_currentPage < _maxPage) {
                  setState(() => _currentPage++);
                  _speak(question);
                }
              },
            ),
            const SizedBox(height: 8),
            const Text(
              '🔥 Keep practicing to maintain your streak!',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: LinearProgressIndicator(
              value: _currentPage / _maxPage,
              minHeight: 16,
              color: const Color(0xFF0FC753),
              backgroundColor: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(width: 8),
          Text('$_currentPage/$_maxPage'),
        ],
      ),
    );
  }
}
