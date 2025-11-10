// lib/services/streak_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class StreakService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<void> updateLoginStreak() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final userDoc = _firestore.collection('users').doc(user.uid);
    final snapshot = await userDoc.get();

    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    if (snapshot.exists) {
      final data = snapshot.data()!;
      final lastLoginDate = data['lastLoginDate'];
      final streakCount = data['streakCount'] ?? 0;

      if (lastLoginDate == today) {
        // Already logged in today — no update
        return;
      }

      final lastDate = DateTime.parse(lastLoginDate);
      final difference = DateTime.now().difference(lastDate).inDays;

      if (difference == 1) {
        // Consecutive day login → increment streak
        await userDoc.update({
          'streakCount': streakCount + 1,
          'lastLoginDate': today,
        });
      } else {
        // Missed a day → reset streak
        await userDoc.update({
          'streakCount': 1,
          'lastLoginDate': today,
        });
      }
    } else {
      // First login → initialize streak
      await userDoc.set({
        'streakCount': 1,
        'lastLoginDate': today,
      });
    }
  }
}
