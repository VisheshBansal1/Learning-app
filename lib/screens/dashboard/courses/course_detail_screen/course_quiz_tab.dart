import 'package:flutter/material.dart';

class CourseQuizTab extends StatelessWidget {
  final int currentIndex;
  final Map<int, List<Map<String, dynamic>>> quizzes;

  const CourseQuizTab({
    super.key,
    required this.currentIndex,
    required this.quizzes,
  });

  @override
  Widget build(BuildContext context) {
    final videoQuizzes = quizzes[currentIndex] ?? [];

    if (videoQuizzes.isEmpty) {
      return const Center(
        child: Text("No quiz for this video.",
            style: TextStyle(color: Colors.white54)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: videoQuizzes.length,
      itemBuilder: (context, index) {
        final quiz = videoQuizzes[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(12),
            border:
                Border.all(color: Colors.deepPurpleAccent.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(quiz['question'],
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
              const SizedBox(height: 10),
              ...List.generate(
                (quiz['options'] as List).length,
                (i) {
                  final option = quiz['options'][i];
                  return ListTile(
                    leading: const Icon(Icons.circle_outlined,
                        color: Colors.white54, size: 20),
                    title: Text(option,
                        style: const TextStyle(color: Colors.white70)),
                    onTap: () {
                      final correct = quiz['answer'] == option;
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(correct
                            ? "✅ Correct!"
                            : "❌ Wrong! Correct answer: ${quiz['answer']}"),
                        backgroundColor:
                            correct ? Colors.green : Colors.redAccent,
                      ));
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
