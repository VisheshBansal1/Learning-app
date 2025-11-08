import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:learnify/auth/screens/login_screen.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

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
    return Drawer(
        backgroundColor: const Color(0xFF1A1A1A),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.deepPurpleAccent),
              child: Center(
                child: Text(
                  'Learnify Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            _drawerItem(Icons.home, 'Home'),
            _drawerItem(Icons.school, 'My Courses'),
            _drawerItem(Icons.star, 'Favorites'),
            _drawerItem(Icons.person, 'Profile'),
            _drawerItem(Icons.settings, 'Settings'),
            _drawerItem(Icons.logout, 'Logout' ),
          ],
        ),
      );
  }
}

  Widget _drawerItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepPurpleAccent),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: () {

      },
    );
  }