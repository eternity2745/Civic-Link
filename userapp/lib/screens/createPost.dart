import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:userapp/Database/methods.dart';
import 'package:userapp/Utilities/mapLocationPicker.dart';
import 'package:userapp/Utilities/state.dart';

class PostCreateScreen extends StatefulWidget {
  const PostCreateScreen({super.key});

  @override
  State<PostCreateScreen> createState() => _PostCreateScreenState();
}

class _PostCreateScreenState extends State<PostCreateScreen> {

  final TextEditingController _postController = TextEditingController();
  String imagePath = "";

  void createPost() async {
    if(_postController.text != "" && Provider.of<StateManagement>(context, listen: false).reportCoordinates.isNotEmpty) {
      GeoPoint location = GeoPoint(Provider.of<StateManagement>(context, listen: false).reportCoordinates[0], Provider.of<StateManagement>(context, listen: false).reportCoordinates[1]);
      Map<String, dynamic> post = {
        "userID" : Provider.of<StateManagement>(context, listen: false).id,
        "description" : _postController.text,
        "location" : location,
        "locality" : Provider.of<StateManagement>(context, listen: false).reportLocality,
        "image" : "",
        "comments" : 0,
        "reports" : 0,
        "likes" : 0,
        "likesId" : [],
        "dateTime" : FieldValue.serverTimestamp(),
        "action" : false,
        "completed" : false,
      };
      bool result = await DatabaseMethods().createPost(post);
      if (result) {
        if(mounted) {
          Provider.of<StateManagement>(context, listen: false).resetReportLocationAddress();
          _postController.text = "";
          imagePath = "";
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: 
            Text(
              "Post Created Successfully",
              style: TextStyle(
                color: Colors.green
              ),
              ),
            )
            );
        }
        }else{
          if(mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: 
            Text(
              "Issue in creating post! Try Again!!",
              style: TextStyle(
                color: Colors.red
              ),
              ),
            )
          );
        }
      }
    }else if(_postController.text == "") {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error"),
          content: Text("Post cannot be empty"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Ok"),
            )
          ],
        )
      );
    }else if(Provider.of<StateManagement>(context, listen: false).reportCoordinates.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error"),
          content: Text("Location of the issue is needed to create a post"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Ok"),
            )
          ],
        )
      );
    }
  }
  

  Future<void> setImage() async {
    var status = await Permission.mediaLibrary.status;
    if(status.isGranted) {
      final ImagePicker imagePicker = ImagePicker();

      final XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);

      if(image != null) {
        imagePath = image.path;
        setState(() {
          
        });
      }
    }else{
      await Permission.mediaLibrary.request();
    }
  }

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
              onPressed: () {
                setImage();
              }, 
              icon: Icon(Icons.add_photo_alternate_outlined)
              ),
            IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => MapLocationPicker()));
              }, 
              icon: Icon(Icons.add_location_alt_outlined)
              ),
            ElevatedButton(
              onPressed: () {
                createPost();
              }, 
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
                controller: _postController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.edit),
                  hintText: "Write about the issue...",
                  border: InputBorder.none,
                ),
                cursorColor: Colors.green.shade500,
                maxLines: null,
              ),
              SizedBox(height: 1.h,),
              if(imagePath != "")...{
                Container(
                  // height: 35.h,
                  // width: 85.w,
                  constraints: BoxConstraints(
                    maxWidth: 95.w,
                    maxHeight: 42.h
                  ),
                  decoration: BoxDecoration(
                    // image: DecorationImage(image: FileImage(File(imagePath)), fit: BoxFit.fill),
                    borderRadius: BorderRadius.circular(10),
                    // border: Border.all(color: Colors.grey.shade900)
                  ),
                  child:
                      ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                            Image.file(File(imagePath), fit: BoxFit.cover,),
                            IconButton.filledTonal(
                              onPressed: () {
                                imagePath = "";
                                setState(() {
                                  
                                });
                              }, 
                              icon: Icon(Icons.close, size: 0.34.dp,), 
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(Colors.black.withValues(alpha: 0.65)),
                                fixedSize: WidgetStateProperty.all(Size(1.w, 3.h))
                              ),
                              color: Colors.red,
                              // alignment: Alignment.topRight,
                              // constraints: BoxConstraints(
                              //   maxHeight: 10.h,
                              //   maxWidth: 20.w
                              // ),
                              ),
                                ]
                        )
                      )
                ),
                SizedBox(height: 3.h,),
              },
              Consumer<StateManagement>(
                builder: (context, value, child) {
                  if (value.reportLocality != "" || value.reportCoordinates.isNotEmpty) {
                    String address = "${value.addressName}, ${value.reportLocality}, ${value.reportAdministrativeArea}";
                    return Column(
                      children: [
                        Container(
                        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.shade900,
                          // boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 2)]
                        ),
                        child: Row(
                          spacing: 2.w,
                          children: [
                            Icon(Icons.location_on,),
                            Expanded(child: Text(address)),
                            IconButton(onPressed: () {value.resetReportLocationAddress();}, icon: Icon(Icons.delete, color: Colors.red,))
                          ],
                          ),
                        ),
                        SizedBox(height: 2.h,)
                      ],
                    );
                  }else{
                    return SizedBox(height: 0.1.h,);
                  }
                },
              )
            ]
        ),
      ),
      )
    );
  }
}