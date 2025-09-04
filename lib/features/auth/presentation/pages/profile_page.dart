import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  // Generate streak data for 365+ days
  final List<int> streakData = List.generate(
    365,
    (index) => (index * 7) % 5,
  ); // dummy levels 0–4

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileHeader(),
              const SizedBox(height: 16),
              _buildYearlyStreakSection(), // 👈 full year activity grid
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 40,
          backgroundImage: AssetImage('assets/images/avatar.png'),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Hana Johnson',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              'English Language Learner',
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildYearlyStreakSection() {
    final shades = [
      Colors.grey.shade300, // 0 = no activity
      Colors.green.shade100,
      Colors.green.shade300,
      Colors.green.shade500,
      Colors.green.shade700,
    ];

    final now = DateTime.now();
    final startDate = DateTime(now.year, now.month - 11, 1);
    final months = List.generate(12, (i) {
      return DateTime(startDate.year, startDate.month + i, 1);
    });

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.local_fire_department, color: Colors.deepOrange),
              SizedBox(width: 8),
              Text(
                "Activity Streak (12 Months)",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Month Labels
          Row(
            children: months
                .map(
                  (m) => Expanded(
                    child: Text(
                      DateFormat.MMM().format(m),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 8),

          // Contribution Grid
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: months.map((month) {
              final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
              final startIndex =
                  streakData.length -
                  365 +
                  (month.month - startDate.month) * 30; // dummy alignment

              return Expanded(
                child: Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: List.generate(daysInMonth, (dayIndex) {
                    int level =
                        streakData[(startIndex + dayIndex) % streakData.length];
                    return Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: shades[level],
                        borderRadius: BorderRadius.circular(3),
                      ),
                    );
                  }),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),

          const Text(
            "🔥 You're on a 42-day streak! Keep going strong!",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
