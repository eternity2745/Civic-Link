import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:userapp/Screens/progress.dart';
import 'package:userapp/Utilities/dateTimeHandler.dart';
import 'package:userapp/Utilities/state.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> with AutomaticKeepAliveClientMixin {

  final TextEditingController _commentController = TextEditingController();

  void addCommment() async {
    
  }

  @override
  bool get wantKeepAlive => true;

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
                                          backgroundImage: NetworkImage(value.mainPosts![value.mainPostID]['profilePic']),
                                        ),
                                        Text(
                                          value.mainPosts![value.mainPostID]['username'],
                                          style: TextStyle(
                                            fontSize: 0.36.dp,
                                            fontWeight: FontWeight.bold
                                          ),
                                          )
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(DateTimeHandler.getFormattedDate(value.mainPosts![value.mainPostID]['dateTime'])),
                                        Text(DateTimeHandler.getFormattedTime(value.mainPosts![value.mainPostID]['dateTime']))
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(height: 3.h,),
                                Text(
                                  value.mainPosts![value.mainPostID]['description'],
                                  style: TextStyle(
                                    fontSize: 0.28.dp,
                                    color: Colors.white
                                  ),                      
                                ),
                                SizedBox(height: 1.h,),
                                Divider(thickness: 0.8,),
                                // SizedBox(height: 0.5.h,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {}, 
                                        icon: Icon(Icons.favorite_border_rounded)
                                        ),
                                      Text(value.mainPosts![value.mainPostID]['likes'].toString())
                                    ], 
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {}, 
                                        icon: Icon(Icons.mode_comment_outlined)
                                        ),
                                      Text(value.mainPosts![value.mainPostID]['comments'].toString())
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
                                            Icon(value.mainPosts![value.mainPostID]['action'] ? Icons.check_rounded : Icons.close_rounded, color: value.mainPosts![value.mainPostID]['action'] ? Colors.green : Colors.red,)
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
                                            Icon(value.mainPosts![value.mainPostID]['completed'] ? Icons.check_rounded : Icons.close_rounded, color: value.mainPosts![value.mainPostID]['completed'] ? Colors.green : Colors.red,)
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
                    Consumer<StateManagement>(
                      builder: (context, value, child) {
                        if(value.mainPosts![value.mainPostID]['comments'] == 0) {
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
                          return ListView.builder(
                            itemCount: value.mainPosts![value.mainPostID]['comments'],
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder:(context, index) {
                              return Column(
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
                                                child: Image.asset("assets/google.png"),
                                              ),
                                              Text(
                                                "Google India",
                                                style: TextStyle(
                                                  fontSize: 0.36.dp,
                                                  fontWeight: FontWeight.bold
                                                ),
                                                )
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text("25/03/2025"),
                                              Text("4:00 PM")
                                            ],
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 3.h),
                                      Padding(
                                        padding: EdgeInsets.only(left: 5.w),
                                        child: RichText(
                                          text: TextSpan(text: "Hello tehre huuaefuaieb efgagyug feaggfeg ef7agfeg87 eg7g8ef7agf efa7g87efagea7 ea7g87fe78a u8agf8aeg g8efag98f efa...",
                                          style: TextStyle(
                                            fontSize: 0.28.dp,
                                            // color: Colors.white
                                          ),
                                          children: [
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
                                            Text("143"),
                                            SizedBox(width: 8.w,),
                                            Icon(Icons.mode_comment_outlined),
                                            SizedBox(width: 1.w,),
                                            Text("20"),
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
                              );
                            },
                          );
                        }
                      }
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