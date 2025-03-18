import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:userapp/screens/post.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {

  List<List<String>> details = [
    [
      "assets/google.png",
      "Google India",
      ""
    ]
  ];

  @override
  Widget build(BuildContext context) {
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
          child: ListView.builder(
            itemCount: 5,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: ((context) => PostScreen())));
                    },
                    // ignore: avoid_unnecessary_containers
                    child: Container(
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
                                    child: Image.asset("assets/Civic Link.png"),
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
                              text: TextSpan(text: "Hello tehre huuaefuaieb efgagyug feaggfeg ef7agfeg87 eg7g8ef7agf efa7g87efagea7 ea7g87fe78a u8agf8aeg g8efag98f efa...", // 115
                              style: TextStyle(
                                fontSize: 0.3.dp
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
                  ),
                // SizedBox(height: 1.h,)
                Divider(thickness: 0.8,)
                ]
              );
            },
            ),
        ),
      ),
      );
  }
}