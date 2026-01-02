import 'package:flutter/material.dart';

class CertificatesScreen extends StatelessWidget {
  const CertificatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0B1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E0B1E),
        elevation: 0,
        title: const Text("My Certificates"),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          "No certificates available yet",
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
