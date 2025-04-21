import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:sizer/sizer.dart';
import 'package:userapp/Database/methods.dart';
import 'package:userapp/Screens/landing.dart';
import 'package:userapp/Screens/createPost.dart';
import 'package:userapp/Screens/profile.dart';
import 'package:userapp/Screens/search.dart';
import 'package:userapp/Utilities/state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.email});
  final String? email;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final _pageController = PageController();

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }


  Future getUserDetails() async {
    QuerySnapshot details = await DatabaseMethods().getUserInfo(widget.email!);
    log("${details.docs[0]}");
    String username = "${details.docs[0]["username"]}";
    String displayname = "${details.docs[0]["displayname"]}";
    String email = "${details.docs[0]["email"]}";
    String profilePic = "${details.docs[0]["profilePic"]}";
    int userID= details.docs[0]['id'];
    int posts = details.docs[0]['posts'];
    int reports = details.docs[0]['reports'];
    int ranking = details.docs[0]['ranking'];
    String docID = details.docs[0].id;
    QuerySnapshot result = await DatabaseMethods().getUserPosts(userID);
    List<Map<String, dynamic>> userPosts = [];
    int i = 0;
    for(var doc in result.docs) {
      userPosts.add(doc.data() as Map<String, dynamic>);
      userPosts[i]['postID'] = doc.id;
      if(mounted) {      
        if(userPosts[i]['likesId'].contains(userID)) {
          userPosts[i]['liked'] = true;
        }else{
          userPosts[i]['liked'] = false;
        }
      }
      i++;
    }
    log("$userPosts");
    if (mounted) {
      Provider.of<StateManagement>(context, listen: false).setProfile(username, displayname, email, profilePic, ranking, reports, posts, userID, docID);
      Provider.of<StateManagement>(context, listen: false).setUserPosts(posts: userPosts);
      List<Map<String, dynamic>> mainPosts = Provider.of<StateManagement>(context, listen: false).mainPosts!;
      for(var i =0; i < mainPosts.length; i++) {
        if(mainPosts[i]['likesId'].contains(userID)) {
          mainPosts[i]['liked'] = true;
        }
      }
      Provider.of<StateManagement>(context, listen: false).setPosts(mainPosts);
    }
  }

  @override
  void initState() {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);
    if(widget.email != null) {
      getUserDetails();
    }
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
        selectedItemColor: Color(int.parse('0xffECE3CE')),
        unselectedItemColor: Color(int.parse('0xffECE3CE')).withValues(alpha: 0.6),
        
        items: [
          SalomonBottomBarItem(icon: selectedIndex == 0? Icon(Icons.home) : Icon(Icons.home_outlined), title: Text("Home")),
          SalomonBottomBarItem(icon: Icon(Icons.search_rounded), title: Text("Search")),
          SalomonBottomBarItem(icon: Icon(Icons.add_box_rounded), title: Text("Create")),
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
          if(index == 2) {
            Navigator.push(context, MaterialPageRoute(builder: ((context) => PostCreateScreen())));
          }else{
            _pageController.jumpToPage(index);
            setState(() {
            selectedIndex = index;
          });
          }
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