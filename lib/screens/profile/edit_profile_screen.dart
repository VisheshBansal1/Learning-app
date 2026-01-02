import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class EditProfileScreen extends StatefulWidget {
  final String name;
  final String email;
  final String? imagePath;

  const EditProfileScreen({
    super.key,
    required this.name,
    required this.email,
    this.imagePath,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  File? selectedImage;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.name);
    emailController = TextEditingController(text: widget.email);
    if (widget.imagePath != null) {
      selectedImage = File(widget.imagePath!);
    }
  }

  Future<void> pickImageFromGallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    setState(() {
      selectedImage = File(image.path);
    });
  }

  Future<void> pickImageFromCamera() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;
      setState(() {
        selectedImage = File(image.path);
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Camera permission denied')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: h / 3,
            child: Image(
              image: selectedImage != null
                  ? FileImage(selectedImage!)
                  : const NetworkImage(
                          'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
                        )
                        as ImageProvider,
              fit: BoxFit.cover,
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new_outlined),
          ),
          Container(
            margin: EdgeInsets.only(top: h / 3.5),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: ListView(
              shrinkWrap: true,
              children: [
                const SizedBox(height: 70),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Full Name'),
                ),
                const SizedBox(height: 10),
                // TextFormField(
                //   controller: emailController,
                //   decoration: const InputDecoration(labelText: 'Email Address'),
                // ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid)
                          .update({
                            'name': nameController.text.trim(),
                            'profileImage': selectedImage?.path,
                          });
                    }

                    Navigator.pop(context, {
                      'name': nameController.text,
                      'email': widget.email, // email stays same as Auth
                      'imagePath': selectedImage?.path,
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Profile Updated')),
                    );
                  },

                  child: const Text('Save Changes'),
                ),
              ],
            ),
          ),
          Align(
            alignment: const Alignment(0, -0.60),
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 55,
                  backgroundImage: selectedImage != null
                      ? FileImage(selectedImage!)
                      : const NetworkImage(
                              'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
                            )
                            as ImageProvider,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Choose a picture'),
                            content: const Text('Select an option'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  pickImageFromGallery();
                                  Navigator.pop(context);
                                },
                                child: const Text('Gallery'),
                              ),
                              if (Platform.isIOS || Platform.isAndroid)
                                TextButton(
                                  onPressed: () {
                                    pickImageFromCamera();
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Camera'),
                                ),
                            ],
                          );
                        },
                      );
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(6),
                      child: const Icon(
                        Icons.edit,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
