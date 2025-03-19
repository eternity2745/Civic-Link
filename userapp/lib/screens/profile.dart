import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;
  
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
                          backgroundImage: NetworkImage("https://img.freepik.com/free-vector/mans-face-flat-style_90220-2877.jpg?t=st=1742383909~exp=1742387509~hmac=0131701366007062d1e104fe4dac9b7953670db65383cf80fe00003bc07896f6&w=900"),
                          // child: Image.network("https://img.freepik.com/free-vector/mans-face-flat-style_90220-2877.jpg?t=st=1742383909~exp=1742387509~hmac=0131701366007062d1e104fe4dac9b7953670db65383cf80fe00003bc07896f6&w=900"),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Devanarayan V S",
                            style: TextStyle(
                              fontSize: 0.36.dp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                            ),
                            ),
                            Text(
                            "@devanarayanvs",
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
                      Text("20"),
                      SizedBox(width: 10.w),
                      Icon(Icons.edit_document),
                      SizedBox(width: 1.w,),
                      Text("10"),
                      SizedBox(width: 10.w),
                      Icon(Icons.report_problem_rounded),
                      SizedBox(width: 1.w,),
                      Text("0"),
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
              ListView.builder(
                itemCount: 5,
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
                )
          ],
        ),
      ),
    );
  }
}