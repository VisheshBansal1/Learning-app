import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Widget buildTopSection(BuildContext context) {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  final user = auth.currentUser;

  if (user == null) {
    return const Padding(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(
              "https://cdn-icons-png.flaticon.com/512/3135/3135715.png",
            ),
          ),
          SizedBox(width: 12),
          Text(
            'Hello, Guest!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  return StreamBuilder<DocumentSnapshot>(
    stream: firestore.collection('users').doc(user.uid).snapshots(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              CircleAvatar(radius: 20, backgroundColor: Colors.grey),
              SizedBox(width: 12),
              Text(
                'Loading...',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        );
      }

      if (!snapshot.hasData || !snapshot.data!.exists) {
        return const Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                  "https://cdn-icons-png.flaticon.com/512/3135/3135715.png",
                ),
              ),
              SizedBox(width: 12),
              Text(
                'Hello, User!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      }

      final userData = snapshot.data!.data() as Map<String, dynamic>;
      final name = userData['name'] ?? 'User';
      final profileImage = userData['profileImage'] ??
          'https://cdn-icons-png.flaticon.com/512/3135/3135715.png';

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Row(
          children: [
            CircleAvatar(
                  radius: 22,
                  backgroundImage: profileImage != null
                      ? FileImage(File(profileImage!))
                      : const NetworkImage(
                              'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
                            )
                            as ImageProvider,
                ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Hello, ${name.split(" ").first}!',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
