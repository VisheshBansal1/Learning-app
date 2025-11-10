import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:learnify/leaderboard_models/user.dart' as leaderboard;
import 'package:learnify/leaderboard_models/achievement.dart';

import 'achievements_section.dart';
import 'current_user_progress.dart';

class GlobalTab extends StatelessWidget {
  final List<leaderboard.User> globalUsers;
  final List<Achievement> achievements;

  const GlobalTab({
    super.key,
    required this.globalUsers,
    required this.achievements,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: globalUsers.length,
              itemBuilder: (context, i) {
                final u = globalUsers[i];
                final isTop3 = u.rank <= 3;
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 9),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2340),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: isTop3
                        ? [
                            BoxShadow(
                              color: u.trophyColor.withOpacity(0.7),
                              blurRadius: 16,
                              spreadRadius: 2,
                            ),
                          ]
                        : [],
                  ),
                  child: Row(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundImage: NetworkImage(u.avatarUrl),
                            backgroundColor: Colors.grey.shade300,
                          ),
                          if (isTop3)
                            Positioned(
                              right: -4,
                              bottom: -4,
                              child: CircleAvatar(
                                backgroundColor: u.trophyColor,
                                radius: 12,
                                child: const Icon(
                                  Icons.emoji_events_outlined,
                                  size: 16,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              u.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${_fmtXp(u.xp)} XP",
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        u.rank.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          AchievementsSection(achievements: achievements),
          const SizedBox(height: 20),
          const CurrentUserProgress(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  static String _fmtXp(int n) {
    final s = n.toString();
    return s.replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',');
  }
}
