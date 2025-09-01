import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'package:lissan_ai/features/practice_speaking/presentation/bloc/practice_speaking_bloc.dart';
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
  late FlutterTts flutterTts;
  String selectedMode = 'mock'; // <-- make it mutable

  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts();
    _setTtsSettings();

    context.read<PracticeSpeakingBloc>().add(
      const StartPracticeSessionEvent(type: 'interview'),
    );
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
      body: BlocConsumer<PracticeSpeakingBloc, PracticeSpeakingState>(
        listenWhen: (previous, current) {
          return previous.currentQuestion != current.currentQuestion ||
              previous.status != current.status;
        },
        listener: (context, state) {
          if (state.status == BlocStatus.sessionStarted) {
            context.read<PracticeSpeakingBloc>().add(
              const GetInterviewQuestionsEvent(),
            );
          }
          if (state.currentQuestion != null &&
              state.status == BlocStatus.questionsLoaded) {
            _speak(state.currentQuestion!.question);
          }
        },
        builder: (context, state) {
          if (state.status == BlocStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == BlocStatus.error) {
            return Center(
              child: Text(
                state.error ?? 'Something went wrong',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if ((state.status == BlocStatus.questionsLoaded ||
                  state.status == BlocStatus.questionLoading) &&
              state.currentQuestion != null) {
            final currentQuestion = state.currentQuestion!.question;

            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  const Center(child: CircleAvatarWidget(radius: 100, padd: 8)),
                  const SizedBox(height: 16),
                  
                  // Mode buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildCustomButton('Mock Interview', 'mock'),
                      const SizedBox(width: 8),
                      buildCustomButton('Free Speaking', 'free'),
                    ],
                  ),

                  // Call different UI based on selectedMode
                  if (selectedMode == 'mock')
                    _buildMockSection(context, state, currentQuestion)
                  else
                    _buildFreeSpeakingSection(context),
                ],
              ),
            );
          }

          return const Center(
            child: Text('Preparing your practice session...'),
          );
        },
      ),
    );
  }

  /// Mock Interview Section
  Widget _buildMockSection(BuildContext context, PracticeSpeakingState state, String currentQuestion) {
    return Column(
      children: [
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
            gradient: const LinearGradient(
              colors: [Color(0xFFDDFFEF), Color(0xFFE2EFFF)],
            ),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            border: Border.all(
              color: const Color(0xFFA7F3D0),
              width: 1.5,
            ),
          ),
          child: Text(
            'Question $_currentPage of $_maxPage. Let\'s practice this together! 💪',
          ),
        ),
        _buildProgressBar(),
        const SizedBox(height: 8),
        QuestionCard(
          status: state.status == BlocStatus.questionLoading,
          question: currentQuestion,
          onSpeak: () => _speak(currentQuestion),
        ),
        const SpeechPage(),
        const SizedBox(height: 16),
        NavigationButtons(
          currentPage: _currentPage,
          maxPage: _maxPage,
          onPrevious: () {
            if (_currentPage > 1) {
              setState(() => _currentPage--);
            }
            if (state.currentQuestionIndex > 0) {
              context.read<PracticeSpeakingBloc>().add(
                MoveToPreviousQuestionEvent(),
              );
            }
          },
          onNext: () {
            if (_currentPage < _maxPage + 1) {
              setState(() => _currentPage++);
            }
            if (state.currentQuestionIndex < state.questions.length - 1) {
              context.read<PracticeSpeakingBloc>().add(
                MoveToNextQuestionEvent(),
              );
            } else if (state.currentQuestionIndex > 5 || _currentPage > 5) {
              context.read<PracticeSpeakingBloc>().add(
                EndPracticeSessionEvent(sessionId: state.session.sessionId),
              );
            } else {
              context.read<PracticeSpeakingBloc>().add(
                const GetInterviewQuestionsEvent(),
              );
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
    );
  }

  /// Free Speaking Section
  Widget _buildFreeSpeakingSection(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Text(
          '🗣️ Free Speaking Mode',
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 30),
        const SpeechPage(), // Reuse speech recording widget
      ],
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

  Widget buildCustomButton(String text, String mode) {
    final isSelected = selectedMode == mode;
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedMode = mode;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? const Color(0xFF3D72B3) : Colors.grey[200],
        foregroundColor: isSelected ? Colors.white : Colors.black,
      ),
      child: Text(text),
    );
  }
}
