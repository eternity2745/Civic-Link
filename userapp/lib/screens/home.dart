import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:sizer/sizer.dart';
import 'package:userapp/Screens/landing.dart';
import 'package:userapp/Screens/createPost.dart';
import 'package:userapp/Screens/profile.dart';
import 'package:userapp/Screens/search.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final _pageController = PageController();

  @override
  void initState() {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);

    super.initState();
  }

  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {    
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      bottomNavigationBar: SalomonBottomBar(
        backgroundColor: Colors.green.shade900,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        
        items: [
          SalomonBottomBarItem(icon: selectedIndex == 0? Icon(Icons.home) : Icon(Icons.home_outlined), title: Text("Home")),
          SalomonBottomBarItem(icon: Icon(Icons.search_rounded), title: Text("Search")),
          SalomonBottomBarItem(icon: selectedIndex == 2? Icon(Icons.add_box_rounded) : Icon(Icons.add_box_outlined), title: Text("Create")),
          SalomonBottomBarItem(icon: Image.asset("assets/google.png", width: 5.w, height: 3.h,), title: Text("Profile")),
          
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