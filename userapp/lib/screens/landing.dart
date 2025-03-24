import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:userapp/Database/methods.dart';
import 'package:userapp/Screens/post.dart';
import 'package:userapp/Utilities/dateTimeHandler.dart';
import 'package:userapp/Utilities/descriptionTrimmer.dart';
import 'package:userapp/Utilities/state.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  void getPosts() async {
    QuerySnapshot posts = await DatabaseMethods().getMainPosts();
    List<Map<String, dynamic>> mainPosts = [];
    int i = 0;
    for(var doc in posts.docs) {
      mainPosts.add(doc.data() as Map<String, dynamic>);
      mainPosts[i]['postID'] = doc.id;
      i++;
    }

    if(mounted) {
      Provider.of<StateManagement>(context, listen: false).setPosts(mainPosts);
      Navigator.push(context, MaterialPageRoute(builder: ((context) => PostScreen())));
    }
    
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
  void initState() {
    getPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: [Opacity(
        opacity: Provider.of<StateManagement>(context).commentsLoading ? 0.5 : 1,
        child: Scaffold(
          appBar: AppBar(
            forceMaterialTransparency: true,
            title: Text(
              "Civic Link",
              style: TextStyle(
                fontSize: 0.4.dp,
                fontWeight: FontWeight.bold
              ),
              ),
          ),
          body: Padding(
            padding: EdgeInsets.only(top: 2.h),
            child: SingleChildScrollView(
              child: Consumer<StateManagement>(
                builder: (context, value, child) {
                return Skeletonizer(
                  effect: ShimmerEffect(
                    duration: Duration(seconds: 1),
                    baseColor: Colors.grey.shade700,
                    highlightColor: Colors.grey,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight
                  ),
                    enabled: value.mainPostsLoading,
                    child: ListView.builder(
                      itemCount: value.mainPosts!.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                                Provider.of<StateManagement>(context, listen: false).commentsLoading = true;
                                Provider.of<StateManagement>(context, listen: false).mainPostID = index;
                                Provider.of<StateManagement>(context, listen: false).userPostsID = -1;
                                getComments();
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
                                          spacing: 4.w,
                                          children: [
                                            CircleAvatar(
                                              radius: 15,
                                              backgroundColor: Colors.transparent,
                                              backgroundImage: value.mainPostsLoading ? null : NetworkImage(value.mainPosts![index]['profilePic']),
                                              // child: Image.asset("assets/Civic Link.png"),
                                            ),
                                            Text(
                                              value.mainPostsLoading ? "" : value.mainPosts![index]['username'],
                                              style: TextStyle(
                                                fontSize: 0.36.dp,
                                                fontWeight: FontWeight.bold
                                              ),
                                              )
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text(value.mainPostsLoading ? "" : DateTimeHandler.getFormattedDate(value.mainPosts![index]['dateTime'])),
                                            Text(value.mainPostsLoading ? "" : DateTimeHandler.getFormattedTime(value.mainPosts![index]['dateTime']))
                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 3.h),
                                    Padding(
                                      padding: EdgeInsets.only(left: 5.w),
                                      child: RichText(
                                        text: TextSpan(text: value.mainPostsLoading ? "" : DescriptionTrimmer.trimDescription(value.mainPosts![index]['description'], 390),
                                        style: TextStyle(
                                          fontSize: 0.3.dp
                                        ),
                                        children: value.mainPostsLoading ? [] : value.mainPosts![index]['description'].length < 390 ? [] : [
                                          TextSpan(
                                            text: "See More",
                                            style: TextStyle(
                                              fontSize: 0.3.dp,
                                              color: Colors.blue
                                        ), 
                                          )
                                        ]
                                        ),
                                        textAlign: TextAlign.start,
                                        ),
                                    ),
                                    SizedBox(height: 2.h,),
                                    Padding(
                                      padding: EdgeInsets.only(left: 5.w),
                                      child: Skeleton.shade(
                                        child: Row(
                                          children: [
                                            Icon(Icons.favorite_border_rounded),
                                            SizedBox(width: 1.w,),
                                            Text(value.mainPostsLoading ? "" : value.mainPosts![index]['likes'].toString()),
                                            SizedBox(width: 8.w,),
                                            Icon(Icons.mode_comment_outlined),
                                            SizedBox(width: 1.w,),
                                            Text(value.mainPostsLoading ? "" : value.mainPosts![index]['comments'].toString()),
                                            SizedBox(width: 8.w,),
                                            Icon(Icons.bookmark_border_rounded),
                                            // SizedBox(width: 1.w,),
                                            // Text("143"),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                                              ),
                            // SizedBox(height: 1.h,)
                            Divider(thickness: 0.8,)
                            ]
                          ),
                        );
                      },
                      ),
                  );
                }
              ),
            ),
          ),
          ),
      ),
      if(Provider.of<StateManagement>(context).commentsLoading)...{
        Center(child: SizedBox(height: 8.h, width: 8.h,child: CircularProgressIndicator()))
      }
      ]
    );
  }
}