import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learnify/constants/colors.dart';
import 'package:learnify/drawer/drawer_widget/header_section.dart';
import 'package:learnify/screens/profile/profile_screen_widget/info_card.dart';
import 'package:learnify/screens/profile/profile_screen_widget/current_user_progress.dart';
import 'package:learnify/screens/profile/profile_screen_widget/menu_item_tile.dart';
import 'package:learnify/screens/profile/profile_screen_widget/logout_tile.dart';
import 'package:learnify/screens/profile/profile_screen_widget/switch_tile.dart';
import 'package:learnify/screens/profile/profile_screen_widget/language_screen.dart';
import 'package:learnify/screens/profile/profile_screen_widget/certificates_screen.dart';
import 'package:learnify/auth/screens/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return const Scaffold(
        body: Center(child: Text("User not logged in")),
      );
    }

    return Scaffold(
      backgroundColor: MyColors.mainColor,
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .snapshots(),
        builder: (context, snapshot) {
          // 🔄 Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          // ❌ Error
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(
              child: Text(
                "Profile data not found",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final data = snapshot.data!.data()!;
          final name = data['name'] ?? 'User';
          final email = data['email'] ?? '';
          final imagePath = data['profileImage'];
          final streak = data['streakCount'] ?? 0;
          final xp = data['xp'] ?? 0;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 🔥 PROFILE HEADER
                HeaderSection(
                  name: name,
                  email: email,
                  imagePath: imagePath,
                  onProfileUpdated:
                      (updatedName, updatedEmail, updatedImagePath) async {
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(uid)
                            .update({
                              'name': updatedName,
                              'email': updatedEmail,
                              'profileImage': updatedImagePath,
                            });
                      },
                ),

                const SizedBox(height: 20),

                /// 🔥 INFO CARDS
                Row(
                  children: [
                    Expanded(
                      child: InfoCard(
                        icon: Icons.star,
                        label: "XP Points",
                        value: xp.toString(),
                        iconColor: Colors.amber,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: InfoCard(
                        icon: Icons.local_fire_department,
                        label: "Learning Streak",
                        value: "$streak Days",
                        iconColor: Colors.deepOrange,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                /// 🔥 PROGRESS
                const CurrentUserProgress(),

                const SizedBox(height: 24),

                /// 🔥 MENU
                MenuItemTile(
                  icon: Icons.card_membership,
                  title: "My Certificates",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CertificatesScreen(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),

                const Text(
                  "Settings",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                SwitchTile(
                  icon: Icons.dark_mode,
                  title: "Dark Mode",
                  value: true,
                  onChanged: (_) {},
                ),

                SwitchTile(
                  icon: Icons.notifications,
                  title: "Push Notifications",
                  value: true,
                  onChanged: (_) {},
                ),

                MenuItemTile(
                  icon: Icons.language,
                  title: "Language",
                  trailingText: "English",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LanguageScreen(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 30),

                /// 🔥 LOGOUT
                LogoutTile(
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const GoogleLoginScreen(),
                      ),
                      (_) => false,
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
