
  import 'package:flutter/material.dart';
import 'package:learnify/widgets/home_tab_widget/build_learning_card.dart';

Widget buildContinueLearning() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Continue Learning',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 140,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(right: 16),
              children: [
                buildLearningCard(
                  gradientColors: [
                    const Color(0xFFD6BA5B),
                    const Color(0xFF3B5A5A),
                  ],
                  title: 'Introduction to Python',
                  progressPercent: 0.75,
                  progressColor: Colors.deepPurpleAccent,
                ),
                const SizedBox(width: 14),
                buildLearningCard(
                  gradientColors: [
                    const Color(0xFF6E7179),
                    const Color(0xFF979C9D),
                  ],
                  title: 'UI/UX Design',
                  progressPercent: 0.3,
                  progressColor: Colors.deepPurpleAccent,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
