import 'package:flutter/material.dart';

class CourseNotesTab extends StatefulWidget {
  final int currentIndex;
  final Map<int, List<String>> userNotes;
  final TextEditingController noteController;

  const CourseNotesTab({
    super.key,
    required this.currentIndex,
    required this.userNotes,
    required this.noteController,
  });

  @override
  State<CourseNotesTab> createState() => _CourseNotesTabState();
}

class _CourseNotesTabState extends State<CourseNotesTab> {
  @override
  Widget build(BuildContext context) {
    final notes = widget.userNotes[widget.currentIndex] ?? [];

    return Column(
      children: [
        Expanded(
          child: notes.isEmpty
              ? const Center(
                  child: Text("No notes yet. Add your own!",
                      style: TextStyle(color: Colors.white54)),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: notes.length,
                  itemBuilder: (context, index) => Card(
                    color: const Color(0xFF1E1E1E),
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: const Icon(Icons.note,
                          color: Colors.deepPurpleAccent),
                      title: Text("Note ${index + 1}",
                          style: const TextStyle(color: Colors.white)),
                      subtitle: Text(notes[index],
                          style: const TextStyle(color: Colors.white70)),
                    ),
                  ),
                ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: const Color(0xFF1A1A1A),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: widget.noteController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Write a note...",
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
                icon: const Icon(Icons.add, color: Colors.deepPurpleAccent),
                onPressed: () {
                  final text = widget.noteController.text.trim();
                  if (text.isNotEmpty) {
                    setState(() {
                      widget.userNotes
                          .putIfAbsent(widget.currentIndex, () => [])
                          .add(text);
                      widget.noteController.clear();
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
