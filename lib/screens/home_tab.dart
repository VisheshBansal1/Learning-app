import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:learnify/auth/screens/login_screen.dart';
import 'package:learnify/constants/colors.dart';
import 'package:learnify/widgets/home_screen_widget/build_continue_learning.dart';
import 'package:learnify/widgets/home_screen_widget/build_info_card.dart';
import 'package:learnify/widgets/home_screen_widget/build_recommended.dart';
import 'package:learnify/widgets/home_screen_widget/build_top_section.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  int _selectedIndex = 0;
  static const backgroundColor = Color(0xFF151022);
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      // 🔹 Always sign out from Firebase first
      await FirebaseAuth.instance.signOut();

      // 🔹 Try signing out from Google, but ignore if not signed in via Google
      final googleSignIn = GoogleSignIn();
      if (await googleSignIn.isSignedIn()) {
        try {
          await googleSignIn.signOut();
          await googleSignIn.disconnect();
        } catch (e) {
          debugPrint('⚠ Google sign-out skipped: $e');
        }
      }

      // 🔹 Navigate back to login screen no matter what
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const GoogleLoginScreen()),
          (route) => false,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Signed out successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error signing out: ${e.toString()}'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.mainColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTopSection(context),
              buildInfoCards(),
              buildContinueLearning(),
              buildRecommended(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ), 
    );
  }
}