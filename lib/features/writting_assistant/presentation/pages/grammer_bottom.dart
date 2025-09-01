import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lissan_ai/features/writting_assistant/presentation/pages/check_grammar_page.dart';
import 'package:lissan_ai/features/writting_assistant/presentation/pages/practice_example_page.dart';

class Grammerbottomnav extends StatefulWidget {
  const Grammerbottomnav({super.key});

  @override
  State<Grammerbottomnav> createState() => _GrammerbottomnavState();
}

class _GrammerbottomnavState extends State<Grammerbottomnav> {
  int _currentIndex = 0;
  String? _practiceText;
  bool _shouldAuthoCheck = false;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      CheckGrammarPage(
        initialText: _practiceText,
        autoCheck: _shouldAuthoCheck,
        onAutoCheckDone: () {
          setState(() {
            _shouldAuthoCheck = false;
            _practiceText = null;
          });
        },
      ),
      PracticeExamplePage(
        onCheck: (text) {
          setState(() {
            _practiceText = text;
            _shouldAuthoCheck = true;
            _currentIndex = 0;
          });
        },
      ),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFF112D4F),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.spellcheck, size: 25),
            label: 'Check Grammar',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Practice'),
        ],
        selectedLabelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.grey,
        ),
      ),
    );
  }
}
