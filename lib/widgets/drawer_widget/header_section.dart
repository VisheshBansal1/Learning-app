import 'dart:io';
import 'package:flutter/material.dart';
import 'package:learnify/screens/profile_screens/edit_profile_screen.dart';
// import 'package:profile_ui_task1/screens/edit_profile_screen.dart';

class HeaderSection extends StatelessWidget {
  final String name;
  final String email;
  final String? imagePath;
  final Function(String, String, String?) onProfileUpdated;

  const HeaderSection({
    super.key,
    required this.name,
    required this.email,
    required this.imagePath,
    required this.onProfileUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 10, 20),
        child: Row(
          spacing: 10,
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: imagePath != null
                      ? FileImage(File(imagePath!))
                      : const NetworkImage(
                              'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
                            )
                            as ImageProvider,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      Icons.camera_alt,
                      size: 12.0,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  email,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfileScreen(
                          name: name,
                          email: email,
                          imagePath: imagePath,
                        ),
                      ),
                    );

                    if (result != null && result is Map<String, dynamic>) {
                      onProfileUpdated(
                        result['name'],
                        result['email'],
                        result['imagePath'],
                      );
                    }
                  },
                  child: Container(
                    height: 25,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Center(
                      child: Text(
                        'Edit Profile',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
