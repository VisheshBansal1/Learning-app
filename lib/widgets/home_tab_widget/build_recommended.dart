import 'package:flutter/material.dart';
import 'package:learnify/widgets/home_tab_widget/build_recommended_card.dart';

Widget buildRecommended() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 24, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recommended for You',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 12),
          buildRecommendedCard(
            tag: 'NEW',
            tagColor: Colors.deepPurple,
            title: 'Advanced JavaScript',
            subtitle: 'Master complex concepts.',
            backgroundColor: const Color(0xFF2C4440),
            imagePlaceholderColor: const Color(0xFF38645A),
          ),
          const SizedBox(height: 12),
          buildRecommendedCard(
            tag: 'POPULAR',
            tagColor: Colors.orange,
            title: 'Data Visualization',
            subtitle: 'Tell stories with data.',
            backgroundColor: const Color(0xFF2C2744),
            imagePlaceholderColor: Colors.white,
          ),
        ],
      ),
    );
  }
