import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:userapp/Database/methods.dart';
import 'package:userapp/Screens/post.dart';
import 'package:userapp/Utilities/dateTimeHandler.dart';
import 'package:userapp/Utilities/descriptionTrimmer.dart';
import 'package:userapp/Utilities/state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  // @override
  // void initState() {
  //   super.initState();
  // }

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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
              child: Column(
                children: [
                  Row(
                    spacing: 3.w,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey.shade900, width: 1.35.w)
                        ),
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          maxRadius: 35,
                          minRadius: 35,
                          backgroundImage: NetworkImage(Provider.of<StateManagement>(context).profilePic),
                          // child: Image.network("https://img.freepik.com/free-vector/mans-face-flat-style_90220-2877.jpg?t=st=1742383909~exp=1742387509~hmac=0131701366007062d1e104fe4dac9b7953670db65383cf80fe00003bc07896f6&w=900"),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Provider.of<StateManagement>(context).displayname,
                            style: TextStyle(
                              fontSize: 0.34.dp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                            ),
                            ),
                            Text(
                            "@${Provider.of<StateManagement>(context).username}",
                            style: TextStyle(
                              fontSize: 0.3.dp,
                              fontWeight: FontWeight.bold,
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
                      Text(Provider.of<StateManagement>(context).ranking.toString()),
                      SizedBox(width: 10.w),
                      Icon(Icons.edit_document),
                      SizedBox(width: 1.w,),
                      Text(Provider.of<StateManagement>(context).posts.toString()),
                      SizedBox(width: 10.w),
                      Icon(Icons.report_problem_rounded),
                      SizedBox(width: 1.w,),
                      Text(Provider.of<StateManagement>(context).reports.toString()),
                    ],
                  ),
                ],
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
                  if (value.userPosts.isEmpty) {
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
                    return ListView.builder(
                      itemCount: value.userPosts.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder:(context, index) {
                        return GestureDetector(
                          onTap: () {
                            Provider.of<StateManagement>(context, listen: false).commentsLoading = true;
                            Provider.of<StateManagement>(context, listen: false).userPostsID = index;
                            Provider.of<StateManagement>(context, listen: false).mainPostID = -1;
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
                                            backgroundImage: NetworkImage(value.profilePic),
                                            // child: Image.network(value.profilePic),
                                          ),
                                          Text(
                                            value.displayname,
                                            style: TextStyle(
                                              fontSize: 0.34.dp,
                                              fontWeight: FontWeight.bold
                                            ),
                                            )
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text(DateTimeHandler.getFormattedDate(value.userPosts[index]['dateTime'])),
                                          Text(DateTimeHandler.getFormattedTime(value.userPosts[index]['dateTime']))
                                          // Text(value.userPosts[index]['dateTime'].runtimeType.toString()),
                                          // Text(value.userPosts[index]['dateTime'].runtimeType.toString())
                                        ],
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 3.h),
                                  Padding(
                                    padding: EdgeInsets.only(left: 5.w),
                                    child: RichText(
                                      text: TextSpan(text: DescriptionTrimmer.trimDescription(value.userPosts[index]['description'], 430),
                                      style: TextStyle(
                                        fontSize: 0.3.dp,
                                        // color: Colors.white
                                      ),
                                      children: value.userPosts[index]['description'].length > 430
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
                                  if(value.userPosts[index]['image'] != '')...{
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
                                            child: Image.network(value.userPosts[index]['image'], fit: BoxFit.cover,),
                                          )
                                      ),
                                    ),
                                    SizedBox(height: 2.h,),
                                    },
                                  Padding(
                                    padding: EdgeInsets.only(left: 5.w),
                                    child: Row(
                                      children: [
                                        Icon(Icons.favorite_border_rounded),
                                        SizedBox(width: 1.w,),
                                        Text(value.userPosts[index]['likes'].toString()),
                                        SizedBox(width: 8.w,),
                                        Icon(Icons.mode_comment_outlined),
                                        SizedBox(width: 1.w,),
                                        Text(value.userPosts[index]['comments'].toString()),
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
                      );
                  }
                }
              )
          ],
        ),
      ),
    );
  }
}