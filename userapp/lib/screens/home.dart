import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:sizer/sizer.dart';
import 'package:userapp/screens/landing.dart';
import 'package:userapp/screens/createPost.dart';
import 'package:userapp/screens/profile.dart';
import 'package:userapp/screens/search.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final _pageController = PageController();

  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SalomonBottomBar(
        backgroundColor: Colors.green.shade900,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        items: [
          SalomonBottomBarItem(icon: Icon(Icons.home), title: Text("Home")),
          SalomonBottomBarItem(icon: Icon(Icons.search_rounded), title: Text("Search")),
          SalomonBottomBarItem(icon: Icon(Icons.add), title: Text("Create")),
          SalomonBottomBarItem(icon: Icon(Icons.person_outline_rounded), title: Text("Profile")),
          
        ],
        currentIndex: selectedIndex,
        onTap: (index) {
          _pageController.jumpToPage(index);
          setState(() {
            selectedIndex = index;
          });
      },
        ),
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
          children: [LandingScreen(), SearchScreen(), PostCreateScreen(), ProfileScreen()],
        
        ),
    );
  }
}