import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:learnify/constants/colors.dart';
import 'package:learnify/auth/screens/login_screen.dart';
import 'package:learnify/widgets/drawer_widget/header_section.dart';
import 'package:learnify/widgets/leaderboard_screen_widgets/current_user_progress.dart';
import 'package:learnify/widgets/profile_screen_widget/certificates_screen.dart';
import 'package:learnify/widgets/profile_screen_widget/info_card.dart';
import 'package:learnify/widgets/profile_screen_widget/language_screen.dart';
import 'package:learnify/widgets/profile_screen_widget/logout_tile.dart';
import 'package:learnify/widgets/profile_screen_widget/menu_item_tile.dart';
import 'package:learnify/widgets/profile_screen_widget/switch_tile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isDarkMode = true;
  bool pushNotifications = false;

  String userName = '';
  String userEmail = '';
  String? userImagePath;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  /// 🧩 Fetch user data from Firestore
  Future<void> _loadUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (snapshot.exists) {
        setState(() {
          userName = snapshot['name'] ?? '';
          userEmail = snapshot['email'] ?? user.email ?? '';
          userImagePath = snapshot['profileImage'];
        });
      }
    }
  }

  /// 🧩 Update profile info when changed anywhere (Drawer/EditProfile)
  void _updateProfile(String name, String email, String? imagePath) {
    setState(() {
      userName = name;
      userEmail = email;
      userImagePath = imagePath;
    });
  }

  void _toggleDarkMode(bool value) => setState(() => isDarkMode = value);

  void _logout() {
    FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const GoogleLoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.mainColor,
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          if (snapshot.hasError ||
              !snapshot.hasData ||
              !snapshot.data!.exists) {
            return const Center(
              child: Text(
                "Failed to load profile",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final name = userData['name'] ?? 'User';
          final email =
              userData['email'] ??
              FirebaseAuth.instance.currentUser?.email ??
              '';
          final imagePath = userData['profileImage'];

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                /// ✅ Profile Header (auto-sync with Firestore)
                HeaderSection(
                  name: name,
                  email: email,
                  imagePath: imagePath,
                  onProfileUpdated: _updateProfile,
                ),

                const SizedBox(height: 20),

                /// ✅ Info Cards
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const InfoCard(
                      icon: Icons.star,
                      label: "XP Points",
                      value: "1,250",
                      iconColor: Colors.amber,
                    ),
                    StreamBuilder<DocumentSnapshot>(
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

                        final data =
                            snapshot.data!.data() as Map<String, dynamic>?;
                        final streak = data?['streakCount'] ?? 1;

                        return InfoCard(
                          icon: Icons.local_fire_department,
                          label: "Learning Streak",
                          value: "$streak Days",
                          iconColor: Colors.deepOrange,
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                CurrentUserProgress(),
                const SizedBox(height: 20),

                /// ✅ Menu Items
                MenuItemTile(
                  icon: Icons.card_membership,
                  title: "My Certificates",
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CertificatesScreen(),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// ✅ Settings Section
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Settings",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                SwitchTile(
                  icon: Icons.dark_mode,
                  title: "Dark Mode",
                  value: isDarkMode,
                  onChanged: _toggleDarkMode,
                ),
                SwitchTile(
                  icon: Icons.notifications,
                  title: "Push Notifications",
                  value: pushNotifications,
                  onChanged: (v) => setState(() => pushNotifications = v),
                ),
                MenuItemTile(
                  icon: Icons.language,
                  title: "Language",
                  trailingText: "English",
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LanguageScreen()),
                  ),
                ),

                const SizedBox(height: 20),
                LogoutTile(onTap: _logout),
              ],
            ),
          );
        },
      ),
    );
  }
}
