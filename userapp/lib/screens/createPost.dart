import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PostCreateScreen extends StatefulWidget {
  const PostCreateScreen({super.key});

  @override
  State<PostCreateScreen> createState() => _PostCreateScreenState();
}

class _PostCreateScreenState extends State<PostCreateScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Text(
          "Create New Post",
          style: TextStyle(
            fontSize: 0.4.dp,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 8.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {}, 
              icon: Icon(Icons.image_outlined)
              ),
            IconButton(
              onPressed: () {}, 
              icon: Icon(Icons.add_location_alt_outlined)
              ),
            ElevatedButton(
              onPressed: () {}, 
              style: ElevatedButton.styleFrom(
                enableFeedback: true,
                backgroundColor: Colors.green.shade900,
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
              ),
              child: Row(
                spacing: 3.w,
                children: [
                  Icon(Icons.add_box_rounded, color: Colors.white, size: 0.35.dp,),
                  Text("Create", style: TextStyle(
                    color: Colors.white,
                    fontSize: 0.3.dp
                  ),)
                ],
              )
              )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 5.h),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.edit),
                  hintText: "Write about the issue...",
                  border: InputBorder.none,
                ),
                cursorColor: Colors.green.shade500,
                maxLines: null,
              ),
              // SizedBox(height: 3.h,),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceAround,
              //   children: [
              //     ElevatedButton(
              //       onPressed: () {}, 
              //       child: Row(
              //         spacing: 2.w,
              //         children: [
              //           Icon(Icons.image_outlined),
              //           Text("Add Image")
              //         ],
              //       )
              //       ),
              //       ElevatedButton(
              //       onPressed: () {}, 
              //       child: Row(
              //         spacing: 2.w,
              //         children: [
              //           Icon(Icons.add_location_alt_outlined),
              //           Text("Add Location")
              //         ],
              //       )
              //       )
              //   ],
              // ),
              // SizedBox(height: 2.h,),
              // Center(
              //   child: ElevatedButton(
              //     style: ElevatedButton.styleFrom(
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(8)
              //       )
              //     ),
              //     onPressed: () {}, 
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       spacing: 2.w,
              //       children: [
              //         Icon(
              //           Icons.add,
              //           size: 0.33.dp,
              //           ),
              //         Text(
              //           "Publish Post",
              //           style: TextStyle(
              //             fontSize: 0.3.dp
              //           ),
              //           )
              //       ],
              //     )
              //     ),
              // ),
            ]
        ),
      ),
      )
    );
  }
}