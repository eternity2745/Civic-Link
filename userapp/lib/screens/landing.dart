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
    for(var doc in posts.docs) {
      mainPosts.add(doc.data() as Map<String, dynamic>);
    }

    if(mounted) {
      Provider.of<StateManagement>(context, listen: false).setPosts(mainPosts);
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
    return Scaffold(
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
                            Navigator.push(context, MaterialPageRoute(builder: ((context) => PostScreen())));
                          },
                      child: Column(
                        children: [
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
                                    text: TextSpan(text: value.mainPostsLoading ? "" : DescriptionTrimmer.trimDescription(value.mainPosts![index]['description'], 390), // 115
                                    style: TextStyle(
                                      fontSize: 0.3.dp
                                    ),
                                    children: value.mainPostsLoading ? [] : value.mainPosts![index]['description'].length < 410 ? [] : [
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
      );
  }
}