import 'package:authorityapp/Database/methods.dart';
import 'package:authorityapp/Screens/post.dart';
import 'package:authorityapp/Utilities/dateTimeHandler.dart';
import 'package:authorityapp/Utilities/descriptionTrimmer.dart';
import 'package:authorityapp/Utilities/state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {

  @override
  bool get wantKeepAlive => true;

  late final AnimationController likesController;

  final TextEditingController filterController = TextEditingController();

  late LocationData locationData;

  void getPosts() async {
    QuerySnapshot posts = await DatabaseMethods().getMainPosts(Provider.of<StateManagement>(context, listen: false).locality);
    List<Map<String, dynamic>> mainPosts = [];
    int i = 0;
    for(var doc in posts.docs) {
      mainPosts.add(doc.data() as Map<String, dynamic>);
      mainPosts[i]['postID'] = doc.id;
      if(mounted) {      
        if(mainPosts[i]['likesId'].contains(Provider.of<StateManagement>(context, listen: false).id)) {
          mainPosts[i]['liked'] = true;
        }else{
          mainPosts[i]['liked'] = false;
        }
      }
      i++;
    }

    if(mounted) {
      Provider.of<StateManagement>(context, listen: false).setPosts(mainPosts);
      // Navigator.push(context, MaterialPageRoute(builder: ((context) => PostScreen())));
    }
  }

  void getComments() async {
    Provider.of<StateManagement>(context, listen: false).commentsLoading = true;
    String postID = "";
    int mainPostID = -1;
    mainPostID = Provider.of<StateManagement>(context, listen: false).mainPostID;
    postID = Provider.of<StateManagement>(context, listen: false).mainPosts![mainPostID]['postID'];

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
    likesController = AnimationController(vsync: this, duration: Duration(milliseconds: 100));
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
                fontWeight: FontWeight.bold,
                fontFamily: "Playwrite",
                color: Colors.green
              ),
              ),
          ),
          body: Padding(
                    padding: EdgeInsets.only(top: 2.h),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          RichText(text: TextSpan(text: "Showing Posts from ", style: TextStyle(
                            fontSize: 0.32.dp
                          ),
                          children: [TextSpan(
                            text: Provider.of<StateManagement>(context).locality,
                            style: TextStyle(
                              fontWeight: FontWeight.bold
                            )
                          )
                          ]
                          ), 
                          textAlign: TextAlign.start,
                          ),
                          Consumer<StateManagement>(
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
                                            getComments();
                                          },
                                      child: Column(
                                        children: [
                                          
                                          // ignore: avoid_unnecessary_containers
                                          Container(
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
                                                            fontSize: 0.34.dp,
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
                                                if(value.mainPostsLoading == false && value.mainPosts![index]['image'] != '')...{
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
                                                        child: Image.network(value.mainPosts![index]['image'], fit: BoxFit.cover,),
                                                      )
                                                  ),
                                                ),
                                                SizedBox(height: 2.h,),
                                                },
                                                Padding(
                                                  padding: EdgeInsets.only(left: 5.w),
                                                  child: Skeleton.shade(
                                                    child: Row(
                                                      children: [
                                                        Icon(value.mainPostsLoading ? Icons.favorite_border_rounded : value.mainPosts![index]['liked'] == true ? Icons.favorite : Icons.favorite_border_rounded, color: value.mainPostsLoading ? null : value.mainPosts![index]['liked'] == true ? Colors.red : null,),
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
                        ],
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