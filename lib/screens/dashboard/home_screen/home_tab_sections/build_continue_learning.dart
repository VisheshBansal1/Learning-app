import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'learning_card.dart';
import '../lesson_screen.dart';

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
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .collection('courses')
                  .orderBy('lastAccessed', descending: true)
                  .limit(5)
                  .snapshots(),
              builder: (context, snapshot) {
                // 🔄 Loading
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  );
                }

                // ❌ Empty
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      'No ongoing courses',
                      style: TextStyle(color: Colors.white54),
                    ),
                  );
                }

                final docs = snapshot.data!.docs;

                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(right: 16),
                  itemCount: docs.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 14),
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    final data = doc.data();

                    return LearningCard(
                      title: data['title'] ?? 'Untitled Course',
                      progress: (data['progress'] ?? 0) as int,
                      gradientStart: Color(
                        data['gradientStart'] ?? 0xFF6E7179,
                      ),
                      gradientEnd: Color(
                        data['gradientEnd'] ?? 0xFF979C9D,
                      ),
                      onTap: () async {
                        // 🔥 Update last accessed
                        await doc.reference.update({
                          'lastAccessed': FieldValue.serverTimestamp(),
                        });

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => LessonScreen(
                              courseId: doc.id,
                            ),
                          ),
                        );
                      },
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
