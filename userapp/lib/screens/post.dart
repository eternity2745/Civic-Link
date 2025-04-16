import 'dart:developer';
import 'package:lottie/lottie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_icons/icons8.dart';
// import 'package:flutter_animated_icons/lottiefiles.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:userapp/Database/methods.dart';
import 'package:userapp/Screens/progress.dart';
import 'package:userapp/Utilities/dateTimeHandler.dart';
import 'package:userapp/Utilities/descriptionTrimmer.dart';
import 'package:userapp/Utilities/state.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {

  final TextEditingController _commentController = TextEditingController();
  int fakeCounter = 0;
  late final AnimationController _likeController;

  void addCommment() async {
    String postID = "";
    int mainPostID = -1;
    if(Provider.of<StateManagement>(context, listen: false).mainPostID == -1) {
      mainPostID = Provider.of<StateManagement>(context, listen: false).userPostsID;
      postID = Provider.of<StateManagement>(context, listen: false).userPosts[mainPostID]['postID'];
    }else{
      mainPostID = Provider.of<StateManagement>(context, listen: false).mainPostID;
      postID = Provider.of<StateManagement>(context, listen: false).mainPosts![mainPostID]['postID'];
    }

    Map<String, dynamic> comment = {
      "description" : _commentController.text,
      "username" : Provider.of<StateManagement>(context, listen: false).displayname,
      "profilePic" : Provider.of<StateManagement>(context, listen: false).profilePic,
      "userID" : Provider.of<StateManagement>(context, listen: false).id,
      "replies" : 0,
      "dateTime" : Timestamp.now(),
      "likes" : 0,
      "likesID" : [],
    };

    var result = await DatabaseMethods().addComment(comment, postID);
    if(mounted) {
      if(result) {
        Provider.of<StateManagement>(context, listen: false).addUserComment(comment);
        _commentController.clear();
        Provider.of<StateManagement>(context, listen: false).mainPosts![mainPostID]['comments'] += 1;
        Provider.of<StateManagement>(context, listen: false).userPosts[mainPostID]['comments'] += 1;
      }else{
        IconSnackBar.show(
          context,
          label: "Unable to add new comment",
          snackBarType: SnackBarType.fail,
          labelTextStyle: TextStyle(color: Colors.white)
        );
      }
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
    }
  }

  void addLike(int index) async {
    String postID = "";
    int mainPostID = -1;
    Provider.of<StateManagement>(context, listen: false).addLike(index);
    int userID = Provider.of<StateManagement>(context, listen: false).id;
    if(Provider.of<StateManagement>(context, listen: false).mainPostID == -1) {
      mainPostID = Provider.of<StateManagement>(context, listen: false).userPostsID;
      postID = Provider.of<StateManagement>(context, listen: false).userPosts[mainPostID]['postID'];
    }else{
      mainPostID = Provider.of<StateManagement>(context, listen: false).mainPostID;
      postID = Provider.of<StateManagement>(context, listen: false).mainPosts![mainPostID]['postID'];
    }

    bool result = await DatabaseMethods().addLike(postID, userID);
    if(!result && mounted) {
      Provider.of<StateManagement>(context, listen: false).removeLike(index);
    }
  }

  void removeLike(int index) async {
    String postID = "";
    int mainPostID = -1;
    Provider.of<StateManagement>(context, listen: false).removeLike(index);
    int userID = Provider.of<StateManagement>(context, listen: false).id;
    if(Provider.of<StateManagement>(context, listen: false).mainPostID == -1) {
      mainPostID = Provider.of<StateManagement>(context, listen: false).userPostsID;
      postID = Provider.of<StateManagement>(context, listen: false).userPosts[mainPostID]['postID'];
    }else{
      mainPostID = Provider.of<StateManagement>(context, listen: false).mainPostID;
      postID = Provider.of<StateManagement>(context, listen: false).mainPosts![mainPostID]['postID'];
    }

    bool result = await DatabaseMethods().removeLike(postID, userID);
    if(!result && mounted) {
      Provider.of<StateManagement>(context, listen: false).addLike(index);
    }
  }

  @override
  bool get wantKeepAlive => true;

  // @override
  // void initState() {
  //   log("INIT STATE");
  //   if(fakeCounter != 0) {
  //     getComments();
  //   }else{
  //     fakeCounter++;
  //   }
  //   super.initState();
  // }

  @override
  void initState() {
    super.initState();
    _likeController = AnimationController(vsync: this, duration: Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Text(
          "Post",
          style: TextStyle(
            fontSize: 0.4.dp,
            fontWeight: FontWeight.bold
          ),
          ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(top: 2.h, bottom: 4.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: EdgeInsets.only(left: 5.w, top: 3.h, right: 5.w, bottom: 1.5.h),
                        child: Consumer<StateManagement>(
                          builder: (context, value, child) {
                          // String postID = "";
                          // int mainPostID = -1;
                          Map<String, dynamic> posts = {};
                          int id = -1;
                          if(value.mainPostID == -1) {
                            id = value.userPostsID;
                            posts = value.userPosts[id];
                            log("$posts");
                          }else{
                            id = value.mainPostID;
                            posts = value.mainPosts![id];
                          }
                          return Column(
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
                                          backgroundImage: NetworkImage(posts['profilePic']),
                                        ),
                                        Text(
                                          posts['username'],
                                          style: TextStyle(
                                            fontSize: 0.32.dp,
                                            fontWeight: FontWeight.bold
                                          ),
                                          )
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(DateTimeHandler.getFormattedDate(posts['dateTime'])),
                                        Text(DateTimeHandler.getFormattedTime(posts['dateTime']))
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(height: 3.h,),
                                Text(
                                  posts['description'],
                                  style: TextStyle(
                                    fontSize: 0.28.dp,
                                    color: Colors.white
                                  ),                      
                                ),
                                if(posts['image'] != '')...{
                                  SizedBox(height: 2.h,),
                                    Center(
                                      child: Container(
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
                                            child: Image.network(posts['image'], fit: BoxFit.cover,),
                                          )
                                      ),
                                    ),
                                },
                                SizedBox(height: 1.h,),
                                Divider(thickness: 0.8,),
                                // SizedBox(height: 0.5.h,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          if (_likeController.status ==
                                              AnimationStatus.dismissed) {
                                              addLike(id);
                                              _likeController.reset();
                                              _likeController.animateTo(0.6);
                                          } else {
                                            removeLike(id);
                                            _likeController.reverse();
                                          }
                                        },
                                      icon: Lottie.asset(Icons8.heart_color,
                                        controller: _likeController, 
                                        height: 3.8.h,
                                        onLoaded: (p0) {
                                          if(posts['liked'] == true) {
                                            _likeController.animateTo(0.6);
                                          }
                                        },
                                        ),
                                      color: Colors.red,
                                      ),
                                      Text(posts['likes'].toString())
                                    ], 
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {}, 
                                        icon: Icon(Icons.mode_comment_outlined)
                                        ),
                                      Text(posts['comments'].toString())
                                    ],
                                    
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {}, 
                                        icon: Icon(Icons.bookmark_border_rounded)
                                        ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {}, 
                                        icon: Icon(Icons.report_problem_outlined)
                                        ),
                                    ],
                                  ),
                                ],
                                ),
                                // SizedBox(height: 0..h,),
                                Divider(thickness: 0.8,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      children: [
                                        Row(
                                          spacing: 3.w,
                                          children: [
                                            Text(
                                              "Action Taken", 
                                              style: TextStyle(
                                                fontSize: 0.3.dp
                                              ),
                                              ),
                                            Icon(posts['action'] ? Icons.check_rounded : Icons.close_rounded, color: posts['action'] ? Colors.green : Colors.red,)
                                          ],
                                        ),
                                        Row(
                                          spacing: 7.w,
                                          children: [
                                            Text(
                                              "Completed", 
                                              style: TextStyle(
                                                fontSize: 0.3.dp
                                              ),
                                              ),
                                            Icon(posts['completed'] ? Icons.check_rounded : Icons.close_rounded, color: posts['completed'] ? Colors.green : Colors.red,)
                                          ],
                                        ),
                                      ],
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => ProgressScreen()));
                                      }, 
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(color: Colors.green.shade900))
                                      ),
                                      child: Row(
                                        spacing: 2.w,
                                        children: [
                                          Icon(Icons.show_chart_rounded, color: Colors.white,),
                                          Text("Progress",
                                          style: TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      )
                                    )
                                  ],
                                ),
                              ]
                            );
                          }
                        )
                    ),
                    Divider(thickness: 3,),
                    Padding(
                      padding: EdgeInsets.only(left: 5.w, top: 2.h),
                      child: Text(
                        "Comments",
                        style: TextStyle(
                          fontSize: 0.38.dp,
                          fontWeight: FontWeight.bold
                        ),
                        ),
                    ),
                    Skeletonizer(
                      effect: ShimmerEffect(
                                  duration: Duration(seconds: 1),
                                  baseColor: Colors.grey.shade700,
                                  highlightColor: Colors.grey,
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight
                                ),
                      enabled: Provider.of<StateManagement>(context).commentsLoading,
                      child: Consumer<StateManagement>(
                        builder: (context, value, child) {
                          log("COMMENTS: ${value.comments!}");
                          if(value.comments!.isEmpty) {
                            return Padding(
                              padding: EdgeInsets.only(top: 3.5.h),
                              child: Center(
                                child: Text(
                                  "No Comments Yet",
                                  style: TextStyle(
                                    fontSize: 0.36.dp,
                                    color: Colors.grey
                                  ),
                                ),
                              ),
                            );
                          }else{
                            log(value.comments!.length.toString());
                            return ListView.builder(
                              itemCount: value.comments!.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder:(context, index) {
                                return Column(
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
                                                  backgroundImage: value.commentsLoading ? null : NetworkImage(value.comments![index]['profilePic']),
                                                ),
                                                Text(
                                                  value.commentsLoading ? "" : value.comments![index]['username'],
                                                  style: TextStyle(
                                                    fontSize: 0.32.dp,
                                                    fontWeight: FontWeight.bold
                                                  ),
                                                  )
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Text(value.commentsLoading ? "" : DateTimeHandler.getFormattedDate(value.comments![index]['dateTime'])),
                                                Text(value.commentsLoading ? "" : DateTimeHandler.getFormattedTime(value.comments![index]['dateTime']))
                                              ],
                                            )
                                          ],
                                        ),
                                        SizedBox(height: 3.h),
                                        Padding(
                                          padding: EdgeInsets.only(left: 5.w),
                                          child: RichText(
                                            text: TextSpan(text: value.commentsLoading ? "" :  DescriptionTrimmer.trimDescription(value.comments![index]['description'], 400),
                                            style: TextStyle(
                                              fontSize: 0.28.dp,
                                              // color: Colors.white
                                            ),
                                            children: value.commentsLoading ? [] : value.comments![index]['description'].length < 400 ? [] : [
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
                                          child: Row(
                                            children: [
                                              Icon(Icons.favorite_border_rounded),
                                              SizedBox(width: 1.w,),
                                              Text(value.commentsLoading ? "" : value.comments![index]['likes'].toString()),
                                              SizedBox(width: 8.w,),
                                              Icon(Icons.keyboard_return_rounded),
                                              SizedBox(width: 1.w,),
                                              Text(value.commentsLoading ? "" : value.comments![index]['replies'].toString()),
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
                                );
                              },
                            );
                          }
                        }
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 2.h, right: 2.w, left: 2.w,),
            child: TextField(
              controller: _commentController,
              maxLines: 5,
              minLines: 1,
              decoration: InputDecoration(
                suffixIcon: IconButton(onPressed: () {addCommment();}, icon: Icon(Icons.send)),
                hintText: "Enter Comment...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15)
                )
              ),
            ),
          )
        ],
      ),
    );
  }
}