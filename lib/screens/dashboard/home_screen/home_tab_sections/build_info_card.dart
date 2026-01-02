import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learnify/screens/profile/profile_screen_widget/info_card.dart';

Widget buildInfoCards() {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Text(
        "Not logged in",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _loadingCards();
        }

        if (snapshot.hasError) {
          return _errorCards();
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return _emptyCards();
        }

        final data = snapshot.data!.data()!;

        final int streakCount = (data['streakCount'] ?? 0) as int;

        int ongoingCourses = 0;

        // FAST METHOD (recommended)
        if (data['activeCourses'] is int) {
          ongoingCourses = data['activeCourses'];
        }

        // BACKUP METHOD (list-based)
        else if (data['courses'] is List) {
          ongoingCourses = (data['courses'] as List)
              .where((c) => (c['progress'] ?? 0) < 100)
              .length;
        }

        return Row(
          children: [
            Expanded(
              child: InfoCard(
                icon: Icons.local_fire_department,
                label: "Learning Streak",
                value: "$streakCount Days",
                iconColor: Colors.deepOrange,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: InfoCard(
                icon: Icons.school_rounded,
                label: "Ongoing Courses",
                value: ongoingCourses.toString(),
                iconColor: Colors.blueAccent,
              ),
            ),
          ],
        );
      },
    ),
  );
}


Widget _loadingCards() {
  return Row(
    children: const [
      Expanded(
        child: InfoCard(
          icon: Icons.local_fire_department,
          label: "Learning Streak",
          value: "...",
          iconColor: Colors.deepOrange,
        ),
      ),
      SizedBox(width: 12),
      Expanded(
        child: InfoCard(
          icon: Icons.school_rounded,
          label: "Ongoing Courses",
          value: "...",
          iconColor: Colors.blueAccent,
        ),
      ),
    ],
  );
}

Widget _errorCards() {
  return const Text(
    "Failed to load data",
    style: TextStyle(color: Colors.redAccent),
  );
}

Widget _emptyCards() {
  return Row(
    children: const [
      Expanded(
        child: InfoCard(
          icon: Icons.local_fire_department,
          label: "Learning Streak",
          value: "0 Days",
          iconColor: Colors.deepOrange,
        ),
      ),
      SizedBox(width: 12),
      Expanded(
        child: InfoCard(
          icon: Icons.school_rounded,
          label: "Ongoing Courses",
          value: "0",
          iconColor: Colors.blueAccent,
        ),
      ),
    ],
  );
}
