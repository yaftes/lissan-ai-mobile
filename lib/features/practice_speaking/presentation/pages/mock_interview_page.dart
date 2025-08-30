import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lissan_ai/features/practice_speaking/presentation/widgets/circle_avatar_widget.dart';
import 'package:lissan_ai/features/practice_speaking/presentation/widgets/menu_widget.dart';

class MockInterviewPage extends StatefulWidget {
  const MockInterviewPage({super.key});

  @override
  State<MockInterviewPage> createState() => _MockInterviewPageState();
}

class _MockInterviewPageState extends State<MockInterviewPage> {
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
        actions: const [
          Padding(padding: EdgeInsets.all(15), child: Icon(Icons.search)),
        ],
      ),
      drawer: const MenuWidget(),
      body: Column(
        spacing: 16,
        children: [
          const Center(
            child: CircleAvatarWidget(radius: 80, width: 140, heigth: 140),
          ),
          Text(
            'Mock Interview Practice',
            style: GoogleFonts.inter(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: CircleAvatarWidget(radius: 40, width: 70, heigth: 70),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12), // rounded corners
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFD7FFD9), 
                          Color(0xFFD7E9FF), 
                        ],
                      ),
                    ),
                    child: const Text(
                      "Question 1 of 5. Let's practice this together!",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
