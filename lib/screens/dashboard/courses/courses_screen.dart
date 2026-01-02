import 'package:flutter/material.dart';
import 'package:learnify/constants/colors.dart';
import 'package:learnify/screens/dashboard/courses/course_detail_screen.dart';

class CourseScreen extends StatefulWidget {
  const CourseScreen({super.key});

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  String selectedCategory = 'All';
  bool isGridView = true;
  String searchQuery = '';

  final List<String> categories = ['All', 'Tech', 'Design', 'Growth'];

  final List<Map<String, dynamic>> courses = [
    {
      'title': 'Flutter Development Masterclass',
      'instructor': 'Angela Yu',
      'thumbnail': 'https://img.youtube.com/vi/fq4N0hgOWzU/0.jpg',
      'playlist': [
        'fq4N0hgOWzU',
        'x0uinJvhNxI',
        '5yrAm5WT7D8',
      ],
    },
    {
      'title': 'Python for Beginners',
      'instructor': 'John Doe',
      'thumbnail': 'https://img.youtube.com/vi/_uQrJ0TkZlc/0.jpg',
      'playlist': [
        '_uQrJ0TkZlc',
        'rfscVS0vtbw',
        'WGJJIrtnfpk',
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredCourses = courses.where((course) {
      final matchesSearch =
          course['title']!.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesSearch || selectedCategory == 'All';
    }).toList();

    return Scaffold(
      backgroundColor: MyColors.mainColor,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Search for a course...',
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                filled: true,
                fillColor: const Color(0xFF1E1E1E),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(color: Colors.white),
              onChanged: (value) => setState(() => searchQuery = value),
            ),
            const SizedBox(height: 16),

            // Category Chips
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isSelected = category == selectedCategory;
                  return GestureDetector(
                    onTap: () => setState(() => selectedCategory = category),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.deepPurpleAccent
                            : const Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        category,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.white70,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Courses List/Grid
            Expanded(
              child: isGridView
                  ? GridView.builder(
                      itemCount: filteredCourses.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.8,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemBuilder: (context, index) {
                        final course = filteredCourses[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CourseDetailScreen(course: course),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E1E1E),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15),
                                  ),
                                  child: Image.network(
                                    course['thumbnail']!,
                                    height: 110,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        course['title']!,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        course['instructor']!,
                                        style: const TextStyle(
                                          color: Colors.white54,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : ListView.builder(
                      itemCount: filteredCourses.length,
                      itemBuilder: (context, index) {
                        final course = filteredCourses[index];
                        return ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              course['thumbnail']!,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(course['title']!,
                              style: const TextStyle(color: Colors.white)),
                          subtitle: Text(course['instructor']!,
                              style: const TextStyle(color: Colors.white70)),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CourseDetailScreen(course: course),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
