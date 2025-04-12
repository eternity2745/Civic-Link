import 'package:authorityapp/Screens/landing.dart';
import 'package:authorityapp/Utilities/state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:sizer/sizer.dart';

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
          SalomonBottomBarItem(icon: CircleAvatar(backgroundImage: NetworkImage(Provider.of<StateManagement>(context).profilePic), maxRadius: 10, minRadius: 10,),
          activeIcon: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey, width: 0.5.w)
                        ),
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          maxRadius: 10,
                          minRadius: 10,
                          backgroundImage: NetworkImage(Provider.of<StateManagement>(context).profilePic),
                          // child: Image.network("https://img.freepik.com/free-vector/mans-face-flat-style_90220-2877.jpg?t=st=1742383909~exp=1742387509~hmac=0131701366007062d1e104fe4dac9b7953670db65383cf80fe00003bc07896f6&w=900"),
                        ),
                      ),
          title: Text("Profile")),
          
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
          children: [LandingScreen(), ProfileScreen()],
        
        ),
    );
  }
}