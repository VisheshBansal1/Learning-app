import 'package:flutter/material.dart';
import 'package:learnify/constants/colors.dart';
import 'package:learnify/screens/course_detail_screen/course_discussion_tab.dart';
import 'package:learnify/screens/course_detail_screen/course_lessons_tab.dart';
import 'package:learnify/screens/course_detail_screen/course_notes_tab.dart';
import 'package:learnify/screens/course_detail_screen/course_quiz_tab.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CourseDetailScreen extends StatefulWidget {
  final Map<String, dynamic> course;

  const CourseDetailScreen({super.key, required this.course});

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  late YoutubePlayerController _controller;
  late List<String> playlist;
  int currentIndex = 0;
  int selectedTabIndex = 0;

  // Shared data
  final Map<int, List<String>> userNotes = {};
  final TextEditingController noteController = TextEditingController();
  final List<Map<String, String>> discussions = [];
  final TextEditingController commentController = TextEditingController();

  final Map<int, List<Map<String, dynamic>>> quizzes = {
    0: [
      {
        'question': "What is Flutter primarily used for?",
        'options': ["Web apps", "Mobile apps", "Databases", "AI tools"],
        'answer': "Mobile apps",
      },
      {
        'question': "Flutter is developed by which company?",
        'options': ["Facebook", "Google", "Microsoft", "Apple"],
        'answer': "Google",
      },
    ],
    1: [
      {
        'question': "What language is used in Flutter?",
        'options': ["Kotlin", "Swift", "Dart", "Java"],
        'answer': "Dart",
      },
      {
        'question': "Which widget manages state in Flutter?",
        'options': ["StatelessWidget", "StatefulWidget", "Container", "Text"],
        'answer': "StatefulWidget",
      },
    ],
    2: [
      {
        'question': "Firebase is mainly used for?",
        'options': [
          "UI Design",
          "Database and Authentication",
          "Animations",
          "State Management",
        ],
        'answer': "Database and Authentication",
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    playlist = widget.course['playlist'];
    _controller = YoutubePlayerController(
      initialVideoId: playlist.first,
      flags: const YoutubePlayerFlags(autoPlay: true, mute: false),
    );
  }

  void playNextVideo(int index) {
    setState(() {
      currentIndex = index;
      _controller.load(playlist[index]);
    });
  }

  Widget _tabButton(String text, int index) {
    final bool isActive = selectedTabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => selectedTabIndex = index),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          text,
          style: TextStyle(
            color: isActive ? Colors.deepPurpleAccent : Colors.white60,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _getSelectedTab() {
    switch (selectedTabIndex) {
      case 0:
        return CourseLessonsTab(
          playlist: playlist,
          currentIndex: currentIndex,
          onVideoSelected: playNextVideo,
        );
      case 1:
        return CourseNotesTab(
          currentIndex: currentIndex,
          userNotes: userNotes,
          noteController: noteController,
        );
      case 2:
        return CourseQuizTab(currentIndex: currentIndex, quizzes: quizzes);
      case 3:
        return CourseDiscussionTab(
          discussions: discussions,
          commentController: commentController,
        );
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(controller: _controller),
      builder: (context, player) {
        return Scaffold(
          backgroundColor: MyColors.mainColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              widget.course['title'],
              style: const TextStyle(color: Colors.white),
            ),
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_sharp),
            ),                                                //changing for back arrow
          ),
          body: SafeArea(
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: AspectRatio(aspectRatio: 16 / 9, child: player),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.course['title'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "by ${widget.course['creator'] ?? 'Unknown'}",
                        style: const TextStyle(color: Colors.white60),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _tabButton("Lessons", 0),
                    _tabButton("Notes", 1),
                    _tabButton("Quizzes", 2),
                    _tabButton("Discussion", 3),
                  ],
                ),
                Container(
                  height: 2,
                  color: Colors.deepPurpleAccent.withOpacity(0.4),
                ),
                Expanded(child: _getSelectedTab()),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    noteController.dispose();
    commentController.dispose();
    super.dispose();
  }
}

// https://drive.google.com/uc?export=download&id=13X1XvK0C_kVKPK76qbL7Bs_cz8HFF42T
