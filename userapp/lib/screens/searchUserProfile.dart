import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:userapp/Database/methods.dart';
import 'package:userapp/Screens/post.dart';
import 'package:userapp/Utilities/dateTimeHandler.dart';
import 'package:userapp/Utilities/descriptionTrimmer.dart';
import 'package:userapp/Utilities/state.dart';

class SearchUserScreen extends StatefulWidget {
  const SearchUserScreen({super.key});

  @override
  State<SearchUserScreen> createState() => _SearchUserScreenState();
}

class _SearchUserScreenState extends State<SearchUserScreen> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  String imagePath = "";

  // @override
  // void initState() {
  //   super.initState();
  // }

  void getUserPosts() async {
    QuerySnapshot userPosts = await DatabaseMethods().getUserPosts(Provider.of<StateManagement>(context, listen: false).searchUsersData[Provider.of<StateManagement>(context, listen: false).searchUserIndex]['id']);
    List<Map<String, dynamic>> posts = [];
    int i = 0;
    for(var doc in userPosts.docs) {
      posts.add(doc.data() as Map<String, dynamic>);
      posts[i]['postID'] = doc.id;
      if(mounted) {      
        if(posts[i]['likesId'].contains(Provider.of<StateManagement>(context, listen: false).id)) {
          posts[i]['liked'] = true;
        }else{
          posts[i]['liked'] = false;
        }
      }
      i++;
    }
    // log("$posts");
    if(mounted) {
      Provider.of<StateManagement>(context, listen: false).setSearchUserPosts(posts);
    }
  }

  @override
  void initState() {
    getUserPosts();
    super.initState();
  }

  void getComments() async {
    Provider.of<StateManagement>(context, listen: false).commentsLoading = true;
    String postID = "";
    int mainPostID = -1;
    if(Provider.of<StateManagement>(context, listen: false).mainPostID == -1) {
      mainPostID = Provider.of<StateManagement>(context, listen: false).userPostsID;
      postID = Provider.of<StateManagement>(context, listen: false).userPosts[mainPostID]['postID'];
    }else{
      mainPostID = Provider.of<StateManagement>(context, listen: false).mainPostID;
      postID = Provider.of<StateManagement>(context, listen: false).mainPosts![mainPostID]['postID'];
    }

    QuerySnapshot result = await DatabaseMethods().getComments(postID);
    List<Map<String, dynamic>> comments = [];
    int i = 0;
    for(var doc in result.docs) {
      comments.add(doc.data() as Map<String, dynamic>);
      comments[i]['commentID'] = doc.id;
      i++;
    }

    if(mounted) {
      Provider.of<StateManagement>(context, listen: false).setComments(comments);
      Navigator.push(context, MaterialPageRoute(builder: ((context) => PostScreen())));
    }
  }
  
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Text(
          "Profile",
          style: TextStyle(
            fontSize: 0.4.dp,
            fontWeight: FontWeight.bold
          ),
          ),
      ),
      body: PopScope(
        onPopInvokedWithResult: (result, data) {
          Provider.of<StateManagement>(context, listen: false).removeSearchUserPosts();
        },
        child: Stack(
          children: [Opacity(
            opacity: Provider.of<StateManagement>(context).showPicOpacity,
            child: SingleChildScrollView(
              physics: Provider.of<StateManagement>(context).showProfilePic == true ? NeverScrollableScrollPhysics() : null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                    child: Consumer<StateManagement>(
                      builder: (context, value, child) {
                      return Column(
                        children: [
                          Row(
                            spacing: 3.w,
                            children: [
                              GestureDetector(
                                onLongPress: () {
                                  HapticFeedback.mediumImpact();
                                  Provider.of<StateManagement>(context, listen: false).profilePicShow();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.grey.shade900, width: 1.35.w)
                                  ),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    maxRadius: 35,
                                    minRadius: 35,
                                    backgroundImage: NetworkImage(value.searchUsersData[value.searchUserIndex]['profilePic']),
                                    // child: Image.network("https://img.freepik.com/free-vector/mans-face-flat-style_90220-2877.jpg?t=st=1742383909~exp=1742387509~hmac=0131701366007062d1e104fe4dac9b7953670db65383cf80fe00003bc07896f6&w=900"),
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 54.w,
                                    child: Text(
                                      value.searchUsersData[value.searchUserIndex]['displayname'],
                                      // minFontSize: 16,
                                      style: TextStyle(
                                        fontSize: 0.31.dp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white
                                      ),
                                      ),
                                  ),
                                    Text(
                                    "@${value.searchUsersData[value.searchUserIndex]['username']}",
                                    style: TextStyle(
                                      fontSize: 0.3.dp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white70
                                    ),
                                    )
                                ],
                              )
                            ],
                          ),
                          Divider(thickness: 0.8,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.leaderboard_rounded),
                              SizedBox(width: 1.w,),
                              Text(value.searchUsersData[value.searchUserIndex]['ranking'] == 0 ? "unranked" : value.searchUsersData[value.searchUserIndex]['ranking'].toString()),
                              SizedBox(width: 10.w),
                              Icon(Icons.edit_document),
                              SizedBox(width: 1.w,),
                              Text(value.searchUsersData[value.searchUserIndex]['posts'].toString()),
                              SizedBox(width: 10.w),
                              Icon(Icons.report_problem_rounded),
                              SizedBox(width: 1.w,),
                              Text(value.searchUsersData[value.searchUserIndex]['reports'].toString()),
                            ],
                          ),
                        ],
                      );
                      }
                    ),
                  ),
                  Divider(thickness: 3,),
                  SizedBox(height: 3.h,),
                  Padding(
                      padding: EdgeInsets.only(left: 5.w),
                      child: Text(
                        "Posts",
                        style: TextStyle(
                          fontSize: 0.4.dp,
                          fontWeight: FontWeight.bold
                        ),
                        ),
                    ),
                    Consumer<StateManagement>(
                      builder: (context, value, child) {
                        if (value.searchUsersData[value.searchUserIndex]['posts'] == 0) {
                          return Padding(
                            padding: EdgeInsets.only(top: 10.h),
                            child: Center(
                              child: Text(
                                "No Posts Yet",
                                style: TextStyle(
                                  fontSize: 0.4.dp
                                )
                                ),
                            ),
                          );
                        }else{
                          // log("${value.searchUserPosts}");
                          return Skeletonizer(
                            effect: ShimmerEffect(
                                    duration: Duration(seconds: 1),
                                    baseColor: Colors.grey.shade700,
                                    highlightColor: Colors.grey,
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight
                                  ),
                            enabled: value.searchUserPosts!.isEmpty,
                            child: ListView.builder(
                              itemCount: value.searchUserPosts!.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder:(context, index) {
                                return GestureDetector(
                                  onTap: () {
                                   
                                  },
                                  child: Column(
                                    children: [
                                    // ignore: avoid_unnecessary_containers
                                    Container(
                                    // height: 30.h,
                                    // decoration: BoxDecoration(
                                    //   color: Colors.grey.shade900
                                    // ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                spacing: 3.w,
                                                children: [
                                                  CircleAvatar(
                                                    radius: 15,
                                                    backgroundColor: Colors.transparent,
                                                    backgroundImage: value.searchUserPosts!.isEmpty ? null : NetworkImage(value.searchUserPosts![index]['profilePic']),
                                                    child: value.searchUserPosts!.isEmpty ? Text("A") : null,
                                                    // child: Image.network(value.profilePic),
                                                  ),
                                                  Text(
                                                    value.searchUserPosts!.isEmpty ? "" : value.searchUserPosts![index]['username'],
                                                    style: TextStyle(
                                                      fontSize: 0.305.dp,
                                                      fontWeight: FontWeight.bold
                                                    ),
                                                    )
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  Text(value.searchUserPosts!.isEmpty ? "" : DateTimeHandler.getFormattedDate(value.searchUserPosts![index]['dateTime']), style: TextStyle(fontSize: 0.26.dp),),
                                                  Text(value.searchUserPosts!.isEmpty ? "" : DateTimeHandler.getFormattedTime(value.searchUserPosts![index]['dateTime']), style: TextStyle(fontSize: 0.26.dp),)
                                                  // Text(value.searchUserPosts[index]['dateTime'].runtimeType.toString()),
                                                  // Text(value.searchUserPosts[index]['dateTime'].runtimeType.toString())
                                                ],
                                              )
                                            ],
                                          ),
                                          SizedBox(height: 3.h),
                                          Padding(
                                            padding: EdgeInsets.only(left: 5.w),
                                            child: RichText(
                                              text: TextSpan(text: value.searchUserPosts!.isEmpty ? "" : DescriptionTrimmer.trimDescription(value.searchUserPosts![index]['description'], 430),
                                              style: TextStyle(
                                                fontSize: 0.3.dp,
                                                // color: Colors.white
                                              ),
                                              children: value.searchUserPosts!.isEmpty ? null : value.searchUserPosts![index]['description'].length > 430
                                                ? [
                                                    TextSpan(
                                                      text: " See More",
                                                      style: TextStyle(
                                                        fontSize: 0.3.dp,
                                                        color: Colors.blue
                                                      ), 
                                                    )
                                                  ]
                                                : [],
                                              ),
                                              textAlign: TextAlign.start,
                                              ),
                                          ),
                                          SizedBox(height: 2.h,),
                                          if((value.searchUserPosts!.isEmpty == false) && (value.searchUserPosts![index]['image'] != ''))...{
                                            Center(
                                              child: Container(
                                                                                // height: 35.h,
                                                                                // width: 85.w,
                                                constraints: BoxConstraints(
                                                maxWidth: 95.w,
                                                maxHeight: 30.h
                                                ),
                                                decoration: BoxDecoration(
                                                // image: DecorationImage(image: FileImage(File(imagePath)), fit: BoxFit.fill),
                                                borderRadius: BorderRadius.circular(10),
                                                // border: Border.all(color: Colors.grey.shade900)
                                                ),
                                                child:
                                                  ClipRRect(
                                                    borderRadius: BorderRadius.circular(10),
                                                    child: Image.network(value.searchUserPosts![index]['image'], fit: BoxFit.cover,),
                                                  )
                                              ),
                                            ),
                                            SizedBox(height: 2.h,),
                                            },
                                          Padding(
                                            padding: EdgeInsets.only(left: 5.w),
                                            child: Row(
                                              children: [
                                                Icon(value.searchUserPosts!.isEmpty ? Icons.favorite : value.searchUserPosts![index]['liked'] == true ? Icons.favorite : Icons.favorite_border_rounded, color: value.searchUserPosts![index]['liked'] == true ? Colors.red : null),
                                                SizedBox(width: 1.w,),
                                                Text(value.searchUserPosts!.isEmpty ? "" : value.searchUserPosts![index]['likes'].toString()),
                                                SizedBox(width: 8.w,),
                                                Icon(Icons.mode_comment_outlined),
                                                SizedBox(width: 1.w,),
                                                Text(value.searchUserPosts!.isEmpty ? "" : value.searchUserPosts![index]['comments'].toString()),
                                                SizedBox(width: 8.w,),
                                                Icon(Icons.bookmark_border_rounded),
                                                // SizedBox(width: 1.w,),
                                                // Text("143"),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Divider(thickness: 0.8,)
                                    ],
                                  ),
                                );
                              },
                              ),
                          );
                        }
                      }
                    )
                ],
              ),
            ),
          ),
          if(Provider.of<StateManagement>(context).showProfilePic)...{
            Positioned(
              top: 25.h,
              left: 20.w,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 100,
                    backgroundColor: Colors.transparent,
                    backgroundImage: imagePath == "" ? NetworkImage(Provider.of<StateManagement>(context, listen: false).searchUsersData[Provider.of<StateManagement>(context, listen: false).searchUserIndex]['profilePic']) : FileImage(File(imagePath)),
                    // child: Image.network(value.profilePic),
                  ),
                  Positioned(
                    left: 40.w,
                    child: 
                  ElevatedButton(
                  onPressed: () {
                    if(imagePath != "") {
                      imagePath = "";
                      setState(() {
                        
                      });
                      return;
                    }
                    Provider.of<StateManagement>(context, listen: false).profilePicHide();
                  }, 
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    backgroundColor: Colors.black.withValues(alpha: 0.5),
                    padding: EdgeInsets.all(10),
                    iconSize: 0.35.dp
                  ),
                  child: Icon(Icons.close, color: Colors.red),
                  ),),
                ]
              ),
            )
          }
          ]
        ),
      ),
    );
  }
}