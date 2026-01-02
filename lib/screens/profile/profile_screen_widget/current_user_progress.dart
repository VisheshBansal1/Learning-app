import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CurrentUserProgress extends StatelessWidget {
  const CurrentUserProgress({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(
        child: Text(
          "Not logged in",
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }

        var userData = snapshot.data!.data() as Map<String, dynamic>? ?? {};

        String name = userData['name'] ?? "You";
        String profileImage = userData['profileImage'] ?? "";
        int xp = userData['xp'] ?? 11250;
        int rank = userData['rank'] ?? 12;
        int nextXpGap = userData['nextXpGap'] ?? 80;

        double progressValue = xp / (xp + nextXpGap);

        ImageProvider? imageProvider;
        if (profileImage.isNotEmpty) {
          if (profileImage.startsWith('http')) {
            imageProvider = NetworkImage(profileImage);
          } else if (File(profileImage).existsSync()) {
            imageProvider = FileImage(File(profileImage));
          }
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF1C1A2E),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.orange.shade300,
                backgroundImage: imageProvider,
                child: imageProvider == null
                    ? const Icon(Icons.person_outline,
                        color: Colors.white, size: 32)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "$xp XP",
                      style: TextStyle(
                        color: Colors.grey.shade300,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progressValue.clamp(0.0, 1.0),
                        backgroundColor: Colors.white.withAlpha(50),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            Colors.deepPurpleAccent),
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "#$rank",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "$nextXpGap XP to next rank",
                      textAlign: TextAlign.end,
                      // overflow: TextOverflow.ellipsis,
                      // maxLines: 1,
                      style: const TextStyle(
                        color: Color(0xFFBDBDBD),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
