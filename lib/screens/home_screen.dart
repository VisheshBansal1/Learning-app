import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:learnify/auth/screens/login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
          debugPrint('⚠️ Google sign-out skipped: $e');
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
      appBar: AppBar(
        title: const Text('Home Screen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _signOut(context),
            tooltip: 'Sign Out',
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Welcome to Home Screen!',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
