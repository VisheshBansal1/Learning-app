import 'package:flutter/material.dart';
import 'package:learnify/constants/colors.dart';
import 'package:learnify/widgets/home_tab_widget/build_continue_learning.dart';
import 'package:learnify/widgets/home_tab_widget/build_info_card.dart';
import 'package:learnify/widgets/home_tab_widget/build_recommended.dart';
import 'package:learnify/widgets/home_tab_widget/build_top_section.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  int _selectedIndex = 0;
  static const backgroundColor = Color(0xFF151022);
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  } 
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.mainColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTopSection(context),
              buildInfoCards(),
              buildContinueLearning(),
              buildRecommended(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ), 
    );
  }
}