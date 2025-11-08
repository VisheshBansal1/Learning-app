import 'package:flutter/material.dart';

Widget buildTopSection(context) {
  //
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
    child: Row(
      children: [
        const CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage(
            "https://images.unsplash.com/photo-1511367461989-f85a21fda167?ixlib=rb-4.1.0&auto=format&fit=crop&w=3000&q=80",
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Text(
            'Hello, Alex!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}
