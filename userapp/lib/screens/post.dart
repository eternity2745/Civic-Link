import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
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
                      SizedBox(height: 3.h,),
                      Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
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
                            Text("324")
                          ], 
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {}, 
                              icon: Icon(Icons.mode_comment_outlined)
                              ),
                            Text("12")
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
                          Row(
                            spacing: 3.w,
                            children: [
                              Text(
                                "Action Taken", 
                                style: TextStyle(
                                  fontSize: 0.3.dp
                                ),
                                ),
                              Icon(Icons.check_rounded, color: Colors.green,)
                            ],
                          ),
                          TextButton(
                            onPressed: () {}, 
                            child: Text("View Progress",
                            style: TextStyle(color: Colors.blue),
                            )
                            )
                        ],
                      ),
                      Divider(thickness: 0.8,),
                    ]
                  )
              ),
              Padding(
                padding: EdgeInsets.only(left: 5.w),
                child: Text(
                  "Comments",
                  style: TextStyle(
                    fontSize: 0.36.dp,
                    fontWeight: FontWeight.bold
                  ),
                  ),
              ),
              ListView.builder(
                itemCount: 5,
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
                                fontSize: 0.28.dp
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
                )
            ],
          ),
        ),
      ),
    );
  }
}