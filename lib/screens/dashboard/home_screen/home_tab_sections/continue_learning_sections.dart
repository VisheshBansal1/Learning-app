import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'build_learning_card.dart';

class ContinueLearningSection extends StatelessWidget {
  const ContinueLearningSection({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) return const SizedBox();

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
            height: 150,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .collection('ongoingCourses')
                  .orderBy('updatedAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                // 🔄 Loading
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  );
                }

                // ❌ No data
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      'No ongoing courses',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                final courses = snapshot.data!.docs;

                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(right: 16),
                  itemCount: courses.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 14),
                  itemBuilder: (context, index) {
                    final data = courses[index].data() as Map<String, dynamic>;

                    return buildLearningCard(
                      title: data['title'] ?? 'Untitled',
                      progressPercent: (data['progress'] ?? 0).toDouble(),
                      gradientColors: [
                        Color(data['gradientStart'] ?? 0xFF6E7179),
                        Color(data['gradientEnd'] ?? 0xFF979C9D),
                      ],
                      progressColor: Colors.deepPurpleAccent,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
