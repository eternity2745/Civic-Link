import 'package:authorityapp/Utilities/state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

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
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Provider.of<StateManagement>(context).username,
                            style: TextStyle(
                              fontSize: 0.34.dp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                            ),
                            ),
                        ],
                      )
                    ],
                  ),
                  Divider(thickness: 0.8,),
            SizedBox(height: 3.h,),
            ],
          ),
        ),
      ]
        )
      )
    );
  }
}