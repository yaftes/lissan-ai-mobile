import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final int currentPage;
  final int maxPage;

  const ProgressBar({
    super.key,
    required this.currentPage,
    required this.maxPage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: LinearProgressIndicator(
              value: currentPage / maxPage,
              minHeight: 16,
              color: const Color(0xFF0FC753),
              backgroundColor: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$currentPage/$maxPage',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
