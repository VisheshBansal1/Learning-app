import 'package:flutter/material.dart';

class CourseDiscussionTab extends StatefulWidget {
  final List<Map<String, String>> discussions;
  final TextEditingController commentController;

  const CourseDiscussionTab({
    super.key,
    required this.discussions,
    required this.commentController,
  });

  @override
  State<CourseDiscussionTab> createState() => _CourseDiscussionTabState();
}

class _CourseDiscussionTabState extends State<CourseDiscussionTab> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: widget.discussions.length,
            itemBuilder: (context, index) {
              final item = widget.discussions[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.deepPurpleAccent,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item['user']!,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(item['comment']!,
                              style: const TextStyle(color: Colors.white70)),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: const Color(0xFF1A1A1A),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: widget.commentController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Write a comment...",
                    hintStyle: const TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: const Color(0xFF2A2A2A),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send, color: Colors.deepPurpleAccent),
                onPressed: () {
                  final text = widget.commentController.text.trim();
                  if (text.isNotEmpty) {
                    setState(() {
                      widget.discussions.add({'user': 'You', 'comment': text});
                      widget.commentController.clear();
                    });
                  }
                },
              )
            ],
          ),
        ),
      ],
    );
  }
}
