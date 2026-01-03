import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learnify/screens/dashboard/courses/course_detail_screen.dart';
import 'learning_card.dart';

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
              builder: (context, userSnap) {
                if (!userSnap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (userSnap.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      'No ongoing courses',
                      style: TextStyle(color: Colors.white54),
                    ),
                  );
                }

                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (_, __) => const SizedBox(width: 14),
                  itemCount: userSnap.data!.docs.length,
                  itemBuilder: (context, index) {
                    final userCourseDoc = userSnap.data!.docs[index];
                    final courseId = userCourseDoc.id;
                    final userData = userCourseDoc.data();

                    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      future: FirebaseFirestore.instance
                          .collection('courses')
                          .doc(courseId)
                          .get(),
                      builder: (context, courseSnap) {
                        if (!courseSnap.hasData ||
                            !courseSnap.data!.exists) {
                          return const SizedBox();
                        }

                        final course = courseSnap.data!.data()!;

                        return LearningCard(
                          title: course['title'] ?? 'Course',
                          progress: userData['progress'] ?? 0,
                          gradientStart:
                              Color(course['gradientStart'] ?? 0xFF6E7179),
                          gradientEnd:
                              Color(course['gradientEnd'] ?? 0xFF979C9D),
                          onTap: () async {
                            await userCourseDoc.reference.update({
                              'lastAccessed':
                                  FieldValue.serverTimestamp(),
                            });

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CourseDetailScreen(
                                  courseId: courseId,
                                  course: course,
                                ),
                              ),
                            );
                          },
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
