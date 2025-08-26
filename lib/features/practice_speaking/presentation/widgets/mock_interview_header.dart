import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'circle_avatar_widget.dart';

class MockInterviewHeader extends StatelessWidget {
  const MockInterviewHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '🎯 Mock Interview Practice',
          style: GoogleFonts.inter(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        Row(
          children: [
            const Padding(
              padding: EdgeInsets.all(10),
              child: CircleAvatarWidget(
                radius: 50,
                width: 40,
                height: 40,
                padd: 5,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFDDFFEF), Color(0xFFE2EFFF)],
                    ),
                  ),
                  child: const Text(
                    "Let's practice this together! 💪",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
