import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'theme/theme_controller.dart';
import 'theme/app_theme.dart';
import 'screens/dashboard/dashboard.dart';
import 'splash_screen/onboarding_wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();

  final themeController = ThemeController();
  await themeController.init();

  runApp(
    ChangeNotifierProvider.value(
      value: themeController,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeController>();

    return OverlaySupport.global(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Learnify',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: theme.themeMode,
        home: const AuthWrapper(),
      ),
    );
  }
}


// 🔹 This widget decides if the user goes to Login or Home
class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  User? _user;
  bool _checking = true;

  @override
  void initState() {
    super.initState();
    _verifyUser();
  }

  Future<void> _verifyUser() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        // 🔹 This forces Firebase to check if the user token is still valid
        await user.reload();
        final refreshedUser = FirebaseAuth.instance.currentUser;

        // if user still valid → go to home
        setState(() {
          _user = refreshedUser;
          _checking = false;
        });
      } on FirebaseAuthException catch (e) {
        // 🔹 If token invalid, user deleted, or session expired
        print('⚠️ FirebaseAuthException: ${e.code}');
        await FirebaseAuth.instance.signOut();
        setState(() {
          _user = null;
          _checking = false;
        });
      } catch (e) {
        print('Error verifying user: $e');
        await FirebaseAuth.instance.signOut();
        setState(() {
          _user = null;
          _checking = false;
        });
      }
    } else {
      // no user at all
      setState(() {
        _user = null;
        _checking = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_checking) {
      return const Scaffold(
        backgroundColor: Color(0xFF151022),
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    if (_user != null) {
      return const HomeScreen();
    } else {
      return OnboardingWrapper();
    }
  }
}
