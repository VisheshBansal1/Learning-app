import 'package:flutter/material.dart';

class CourseLessonsTab extends StatelessWidget {
  final List<String> playlist;
  final int currentIndex;
  final Function(int) onVideoSelected;

  const CourseLessonsTab({
    super.key,
    required this.playlist,
    required this.currentIndex,
    required this.onVideoSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: playlist.length,
      itemBuilder: (context, index) {
        final isActive = index == currentIndex;
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: isActive
                ? Colors.deepPurpleAccent.withOpacity(0.2)
                : const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isActive ? Colors.deepPurpleAccent : Colors.transparent,
              width: 1.2,
            ),
          ),
          child: ListTile(
            leading: Icon(
              isActive ? Icons.play_circle_fill : Icons.play_circle_outline,
              color: isActive ? Colors.deepPurpleAccent : Colors.white60,
            ),
            title: Text("Lesson ${index + 1}",
                style: const TextStyle(color: Colors.white70)),
            subtitle: Text("Video ${index + 1}",
                style: const TextStyle(color: Colors.white38)),
            trailing:
                const Text("12:15", style: TextStyle(color: Colors.white54)),
            onTap: () => onVideoSelected(index),
          ),
        );
      },
    );
  }
}
