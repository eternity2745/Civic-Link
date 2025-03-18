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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 20.h),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.edit),
                  hintText: "Write about the issue...",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))
                ),
                maxLines: 5,
              ),
              SizedBox(height: 3.h,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {}, 
                    child: Row(
                      spacing: 2.w,
                      children: [
                        Icon(Icons.image_outlined),
                        Text("Add Image")
                      ],
                    )
                    ),
                    ElevatedButton(
                    onPressed: () {}, 
                    child: Row(
                      spacing: 2.w,
                      children: [
                        Icon(Icons.add_location_alt_outlined),
                        Text("Add Location")
                      ],
                    )
                    )
                ],
              ),
              SizedBox(height: 2.h,),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)
                    )
                  ),
                  onPressed: () {}, 
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 2.w,
                    children: [
                      Icon(
                        Icons.add,
                        size: 0.33.dp,
                        ),
                      Text(
                        "Publish Post",
                        style: TextStyle(
                          fontSize: 0.3.dp
                        ),
                        )
                    ],
                  )
                  ),
              ),
            ]
        ),
      ),
      )
    );
  }
}