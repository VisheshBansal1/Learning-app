import 'package:flutter/material.dart';
import 'package:learnify/constants/colors.dart';
import 'package:learnify/screens/ai_tutor_screen.dart';
import 'package:learnify/screens/courses_screen.dart';
import 'package:learnify/screens/home_tab.dart';
import 'package:learnify/screens/leaderboard_screen.dart';
import 'package:learnify/screens/notification_screen.dart';
import 'package:learnify/screens/profile_screen.dart';
import 'package:learnify/services/streak_service.dart';
import 'package:learnify/widgets/my_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _initializeStreak();
  }

  Future<void> _initializeStreak() async {
    try {
      await StreakService().updateLoginStreak();
    } catch (e) {
      debugPrint('Error updating streak: $e');
    }
  }

  int _selectedIndex = 0;

  final List<IconData> _icons = [
    Icons.home_outlined,
    Icons.school_outlined,
    Icons.smart_toy_outlined,
    Icons.leaderboard_outlined,
    Icons.person_outline,
  ];

  final List<String> _labels = [
    'Home',
    'Courses',
    'AI Tutor',
    'Leaderboard',
    'Profile',
  ];

  final List<Widget> _screens = [
    const HomeTab(),
    const CourseScreen(),
    const AITutorScreen(),
    LeaderboardScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.mainColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          _labels[_selectedIndex],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return NotificationScreen();
                  },
                ),
              );
            },
            icon: Icon(Icons.notifications),
          ),
        ],
      ),
      drawer: MyDrawer(),
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_icons.length, (index) {
              final isSelected = _selectedIndex == index;
              return GestureDetector(
                onTap: () {
                  setState(() => _selectedIndex = index);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected
                            ? Colors.deepPurpleAccent
                            : Colors.transparent,
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: Colors.deepPurpleAccent,
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                ),
                              ]
                            : [],
                      ),
                      child: Icon(
                        _icons[index],
                        color: isSelected ? Colors.white : Colors.white70,
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _labels[index],
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.white54,
                        fontSize: 12,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
