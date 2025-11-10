import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learnify/widgets/profile_screen_widget/info_card.dart';

Widget buildInfoCards() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Row(
      children: [
        // --- Learning Streak Card ---
        Expanded(
          child: Container(
            // height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            // padding: const EdgeInsets.all(16),
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const InfoCard(
                    icon: Icons.local_fire_department,
                    label: "Learning Streak",
                    value: "Loading...",
                    iconColor: Colors.deepOrange,
                  );
                }

                final data = snapshot.data!.data() as Map<String, dynamic>?;
                final streak = data?['streakCount'] ?? 1;

                return InfoCard(
                  icon: Icons.local_fire_department,
                  label: "Learning Streak",
                  value: "$streak Days",
                  iconColor: Colors.deepOrange,
                );
              },
            ),
          ),
        ),

        const SizedBox(width: 16),

        // --- Courses Card ---
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: InfoCard(icon: Icons.school_sharp, label: 'Ongoing Courses', value: '2', iconColor: Colors.white),
          ),
        ),
      ],
    ),
  );
}
