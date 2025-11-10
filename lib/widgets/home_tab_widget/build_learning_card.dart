import 'package:flutter/material.dart';

Widget buildLearningCard({
  required List<Color> gradientColors,
  required String title,
  required double progressPercent,
  required Color progressColor,
}) {
  return Container(
    width: 220,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      gradient: LinearGradient(
        colors: gradientColors,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Spacer(),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${(progressPercent * 100).round()}% complete',
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        const SizedBox(height: 6),
        LinearProgressIndicator(
          value: progressPercent,
          color: progressColor,
          backgroundColor: Colors.white24,
          minHeight: 6,
        ),
      ],
    ),
  );
}
