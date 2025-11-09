import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:learnify/auth/services/google_auth.dart';
import 'package:learnify/auth/services/internet_con.dart';
import 'package:learnify/constants/colors.dart';
import 'package:learnify/screens/home_screen.dart';


class GoogleLoginScreen extends StatefulWidget {
  const GoogleLoginScreen({super.key});

  @override
  State<GoogleLoginScreen> createState() => _GoogleLoginScreenState();
}

class _GoogleLoginScreenState extends State<GoogleLoginScreen> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final InternetChecker _checker = InternetChecker();

  bool isLoading = false;
  bool _obscurePassword = true;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checker.startListening();
  }

  @override
  void dispose() {
    _checker.stopListening();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // ---------- Google Sign-In ----------
  Future<void> handleGoogleSignIn() async {
    if (isLoading) return;

    setState(() => isLoading = true);

    try {
      bool result = await FirebaseServices().signInWithGoogle();

      if (result) {
        User? user = _auth.currentUser;

        if (user != null && user.email != null) {
          final linkedProviders = user.providerData
              .map((p) => p.providerId)
              .toList();
          final backendProviders = await _auth.fetchSignInMethodsForEmail(
            user.email!,
          );

          final hasPasswordLinked =
              linkedProviders.contains('password') ||
              backendProviders.contains('password');

          if (hasPasswordLinked) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Welcome back, ${user.displayName ?? user.email}!',
                ),
                backgroundColor: Colors.green,
              ),
            );

            if (context.mounted) {
              createUserDocumentIfNotExists();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
              );
            }
          } else {
            String? password = await showPasswordDialog(context);

            if (password == null || password.isEmpty) {
              await _auth.signOut();
              final GoogleSignIn googleSignIn = GoogleSignIn();
              await googleSignIn.signOut();
              await googleSignIn.disconnect();

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Password setup cancelled. Please try again.',
                    ),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }
              return;
            }

            try {
              await user.linkWithCredential(
                EmailAuthProvider.credential(
                  email: user.email!,
                  password: password,
                ),
              );

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Password linked successfully!'),
                  backgroundColor: Colors.green,
                ),
              );

              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                );
              }
            } on FirebaseAuthException catch (e) {
              String message;
              switch (e.code) {
                case 'provider-already-linked':
                  message = 'Provider already linked.';
                  break;
                case 'credential-already-in-use':
                  message = 'This email is already linked to another account.';
                  break;
                case 'invalid-credential':
                  message = 'Invalid credentials — linking failed.';
                  break;
                default:
                  message = 'Linking failed: ${e.code}';
              }
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(message)));
            }
          }
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Google Sign-In was cancelled or failed'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  // ---------- Password Dialog ----------
  Future<String?> showPasswordDialog(BuildContext context) async {
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmController = TextEditingController();
    bool obscure1 = true;
    bool obscure2 = true;
    String? errorText;

    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF1E1C2A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              title: const Text(
                'Set Password',
                style: TextStyle(color: Colors.white),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: passwordController,
                    obscureText: obscure1,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Enter new password',
                      labelStyle: const TextStyle(color: Colors.white70),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscure1 ? Icons.visibility_off : Icons.visibility,
                          color: Colors.white70,
                        ),
                        onPressed: () => setState(() => obscure1 = !obscure1),
                      ),
                      filled: true,
                      fillColor: const Color(0xFF2A2838),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: confirmController,
                    obscureText: obscure2,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Confirm password',
                      labelStyle: const TextStyle(color: Colors.white70),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscure2 ? Icons.visibility_off : Icons.visibility,
                          color: Colors.white70,
                        ),
                        onPressed: () => setState(() => obscure2 = !obscure2),
                      ),
                      filled: true,
                      fillColor: const Color(0xFF2A2838),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  if (errorText != null) ...[
                    const SizedBox(height: 10),
                    Text(
                      errorText!,
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, null),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C4DFF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    final password = passwordController.text.trim();
                    final confirm = confirmController.text.trim();

                    if (password.isEmpty || confirm.isEmpty) {
                      setState(() => errorText = 'Please fill both fields');
                      return;
                    } else if (password != confirm) {
                      setState(() => errorText = 'Passwords do not match');
                      return;
                    } else if (password.length < 8) {
                      setState(
                        () => errorText =
                            'Password must be at least 8 characters',
                      );
                      return;
                    } else if (!RegExp(
                      r'^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])',
                    ).hasMatch(password)) {
                      setState(
                        () => errorText =
                            'Must include upper, lower case letters & a number',
                      );
                      return;
                    }

                    Navigator.pop(context, password);
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ---------- Email/Password Sign-In ----------
  Future<void> handleEmailPasswordSignIn() async {
    if (!_formKey.currentState!.validate()) return;
    if (isLoading) return;

    setState(() => isLoading = true);

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      String message;

      switch (e.code) {
        case 'user-not-found':
          message = 'No user found for this email.';
          break;
        case 'wrong-password':
          message = 'Incorrect password.';
          break;
        case 'invalid-email':
          message = 'Invalid email format.';
          break;
        case 'user-disabled':
          message = 'This account has been disabled.';
          break;
        case 'too-many-requests':
          message = 'Too many attempts. Try again later.';
          break;
        default:
          message = 'Sign-in failed: ${e.code}';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> createUserDocumentIfNotExists() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid);
    final docSnapshot = await userDoc.get();

    if (!docSnapshot.exists) {
      await userDoc.set({
        'name': user.displayName ?? 'New User',
        'email': user.email,
        'profileImage': user.photoURL ?? null,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: MyColors.mainColor,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.07,
            vertical: height * 0.02,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                backgroundImage: AssetImage('assets/logos/App_logo.jpg'),
                radius: 45,
              ),
              const SizedBox(height: 16),
              const Text(
                'Learnify',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 32,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Your AI-powered learning companion',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white54,
                  fontWeight: FontWeight.w300,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: height * 0.04),

              // ---------- Google Sign-In ----------
              GestureDetector(
                onTap: isLoading ? null : handleGoogleSignIn,
                child: Card(
                  color: Colors.black45,
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 20,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/icons/google-logo.jpg',
                          height: 28,
                          width: 28,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          isLoading ? 'Signing In...' : 'Continue with Google',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: height * 0.03),

              // ---------- Divider ----------
              Row(
                children: [
                  Expanded(child: Container(height: 1, color: Colors.white54)),
                  const SizedBox(width: 8),
                  const Text(
                    'or continue with',
                    style: TextStyle(color: Colors.white54),
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: Container(height: 1, color: Colors.white54)),
                ],
              ),
              SizedBox(height: height * 0.03),

              // ---------- Email & Password Form ----------
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Email Address",
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Enter your email",
                        hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                        ),
                        filled: true,
                        fillColor: const Color(0xFF1E1C2A),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter email';
                        } else if (!value.contains('@')) {
                          return 'Invalid email format';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Password",
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: passwordController,
                      obscureText: _obscurePassword,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Enter your password",
                        hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                        ),
                        filled: true,
                        fillColor: const Color(0xFF1E1C2A),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.white70,
                          ),
                          onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),

                    // ---------- Forgot Password ----------
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () async {
                          final email = emailController.text.trim();

                          if (email.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Enter email to reset password'),
                              ),
                            );
                            return;
                          }

                          try {
                            await _auth.sendPasswordResetEmail(email: email);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Reset link sent to $email'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } on FirebaseAuthException catch (e) {
                            final message = e.code == 'user-not-found'
                                ? 'No user found for this email.'
                                : 'Failed to send reset link.';
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(message),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          }
                        },
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(color: Color(0xFF9B8CFF)),
                        ),
                      ),
                    ),

                    // ---------- Sign In Button ----------
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : handleEmailPasswordSignIn,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6C4DFF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          isLoading ? "Signing In..." : "Sign In",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text.rich(
                  TextSpan(
                    text: "By continuing, you agree to Learnify’s ",
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                    children: [
                      TextSpan(
                        text: "Terms of Service",
                        style: const TextStyle(color: Color(0xFF9B8CFF)),
                      ),
                      const TextSpan(text: " and "),
                      TextSpan(
                        text: "Privacy Policy",
                        style: const TextStyle(color: Color(0xFF9B8CFF)),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
