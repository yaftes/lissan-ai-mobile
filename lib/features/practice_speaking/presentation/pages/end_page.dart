import 'package:flutter/material.dart';
import 'package:lissan_ai/features/practice_speaking/data/models/practice_session_result_model.dart';
import 'package:lissan_ai/features/practice_speaking/presentation/pages/mock_interview_page.dart';
import 'package:lissan_ai/features/practice_speaking/presentation/widgets/circle_avatar_widget.dart';

class EndPage extends StatelessWidget {
  final PracticeSessionResultModel feedback;
  final int currentPage;

  const EndPage({super.key, required this.feedback, required this.currentPage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(child: CircleAvatarWidget(radius: 120, padd: 16)),
              const SizedBox(height: 20),

              const Center(
                child: Text(
                  'Practice Session Ended',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3D72B3),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              Text(
                'Final Score: ${feedback.finalScore}%',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),
              Text(
                'Completed: ${feedback.completed}/${feedback.totalQuestions}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 30),

              if (feedback.strengths.isNotEmpty)
                _buildInfoCard(
                  title: 'Strengths',
                  icon: Icons.check_circle,
                  iconColor: Colors.green,
                  items: feedback.strengths,
                  prefix: '✅ ',
                ),

              if (feedback.weaknesses.isNotEmpty)
                _buildInfoCard(
                  title: 'Weaknesses',
                  icon: Icons.warning_amber_rounded,
                  iconColor: Colors.orange,
                  items: feedback.weaknesses,
                  prefix: '⚠️ ',
                ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const MockInterviewPage()), 
          );

          print('');
          print('Retaking session, current page: $currentPage');
          print('');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF112D4F),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text('Retake Session'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required List<dynamic> items,
    required String prefix,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FBFC),
        border: Border.all(color: Colors.black12, width: 0.5),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor),
              const SizedBox(width: 8),
              Text(
                '$title:',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...items.map((item) => Text('$prefix$item')),
        ],
      ),
    );
  }
}
