import 'package:flutter/material.dart';

class MenuItemTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? trailingText;
  final VoidCallback onTap;

  const MenuItemTile({
    super.key,
    required this.icon,
    required this.title,
    this.trailingText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1A2E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.grey[300]),
        title: Text(title,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
        trailing: trailingText != null
            ? Text(trailingText!, style: const TextStyle(color: Colors.grey))
            : const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
        onTap: onTap,
      ),
    );
  }
}
