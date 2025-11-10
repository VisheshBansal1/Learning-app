import 'package:firebase_auth/firebase_auth.dart' as auth; // 👈 alias added
import 'package:flutter/material.dart';
import 'package:learnify/leaderboard_models/achievement.dart';
import 'package:learnify/leaderboard_models/user.dart'; // 👈 your custom User model
import 'package:learnify/widgets/leaderboard_screen_widgets/global_tab.dart';

class LeaderboardScreen extends StatelessWidget {
  LeaderboardScreen({super.key});

  final Color bgColor = const Color(0xFF1C1527);
  final Color inactiveTabColor = const Color(0xFF908CB0);

  final List<User> globalUsers = [
    User(
      name: "Vishesh",
      xp: 15420,
      rank: 1,
      avatarUrl: 'https://randomuser.me/api/portraits/men/68.jpg',
      trophyColor: const Color(0xFFFFD700),
    ),
    User(
      name: "Ankush",
      xp: 14980,
      rank: 2,
      avatarUrl: 'https://randomuser.me/api/portraits/men/65.jpg',
      trophyColor: const Color(0xFFC0C0C0),
    ),
    User(
      name: "Mayank",
      xp: 14500,
      rank: 3,
      avatarUrl: 'https://randomuser.me/api/portraits/men/12.jpg',
      trophyColor: const Color(0xFFCD7F32),
    ),
    User(
      name: "Harkrit",
      xp: 14210,
      rank: 4,
      avatarUrl: 'https://randomuser.me/api/portraits/women/41.jpg',
    ),
    User(
      name: "Sonia",
      xp: 13995,
      rank: 5,
      avatarUrl: 'https://randomuser.me/api/portraits/women/25.jpg',
    ),
  ];

  final List<Achievement> achievements = const [
    Achievement(
      icon: Icons.local_fire_department_outlined,
      label: "7-Day Streak",
      active: true,
    ),
    Achievement(
      icon: Icons.school_outlined,
      label: "Quiz Master",
      active: true,
    ),
    Achievement(
      icon: Icons.emoji_events_outlined,
      label: "Top Learner",
      active: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: bgColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {},
          ),
          title: const Text(
            "Leaderboard",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.settings_outlined, color: Colors.white),
              onPressed: () {},
            ),
          ],
          bottom: TabBar(
            indicatorColor: Colors.purpleAccent,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: inactiveTabColor,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            tabs: const [
              Tab(text: "Global"),
              Tab(text: "Friends"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            GlobalTab(
              globalUsers: globalUsers,
              achievements: achievements,
            ),
            const Center(
              child: Text(
                "Friends Tab Content",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
