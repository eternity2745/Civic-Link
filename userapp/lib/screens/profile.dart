import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:userapp/Database/methods.dart';
import 'package:userapp/Screens/post.dart';
import 'package:userapp/Screens/welcome.dart';
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

  late CloudinaryPublic cloudinary;
  String imagePath = "";

  final TextEditingController _usernameController = TextEditingController();

  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
  }

  Future loadDotEnv() async {
    await dotenv.load();
    final cloudName = dotenv.get("CLOUDNAME");
    final uploadPreset = dotenv.get("UPLOADPRESET");
    cloudinary = CloudinaryPublic(cloudName, uploadPreset);
  }

  @override
  void initState() {
    super.initState();
    loadDotEnv();
  }

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

  Future uploadImage() async {
    String secureUrl;
    final response = await cloudinary.uploadFile(CloudinaryFile.fromFile(imagePath));
    if(response.secureUrl != "" ) {
      secureUrl = response.secureUrl;
      // publicID = response.publicId;
      if(mounted) {
      Provider.of<StateManagement>(context, listen: false).profilePicHide();
      Provider.of<StateManagement>(context, listen: false).updateProfilePic(secureUrl);
      imagePath = "";
      setState(() {
        
      });
      DatabaseMethods().updateProfilePic(secureUrl, Provider.of<StateManagement>(context, listen: false).docID, Provider.of<StateManagement>(context, listen: false).id);
      Provider.of<StateManagement>(context, listen: false).finalUpdateProfilePic(secureUrl);
      }
    }else{
      secureUrl = "error";
      if(mounted) {
        IconSnackBar.show(
            context,
            label: "Couldnt upload image! Try Again!!",
            snackBarType: SnackBarType.fail,
            labelTextStyle: TextStyle(color: Colors.white)
          );
      }
      setState(() {
        
      });
    }
  }

  void changeUserName() {
    if(_usernameController.text != "") {
      // DatabaseMethods().updateUserName(_usernameController.text, Provider.of<StateManagement>(context, listen: false).docID, Provider.of<StateManagement>(context, listen: false).id);
      Provider.of<StateManagement>(context, listen: false).finalUpdateUserName(_usernameController.text);
      _usernameController.clear();
      Navigator.of(context).pop();
      DatabaseMethods().updateUserName(_usernameController.text, Provider.of<StateManagement>(context, listen: false).docID, Provider.of<StateManagement>(context, listen: false).id);
      Provider.of<StateManagement>(context, listen: false).finalchangeProfileUsername(_usernameController.text);
    }
  }

  Future logout() async {
    bool result = await DatabaseMethods().logout();
    if(result && mounted) {
      Provider.of<StateManagement>(context, listen: false).logout();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => WelcomeScreen()), 
        (route) => false
      );
    }else{
      if(mounted) {
        IconSnackBar.show(
          context,
          label: "Couldnt Logout! Try Again!!",
          snackBarType: SnackBarType.fail,
          labelTextStyle: TextStyle(color: Colors.white)
        );
      }
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
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 2.w),
            child: IconButton(
              onPressed: () {
                HapticFeedback.mediumImpact();
                showModalBottomSheet(context: context, builder: (context) => Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Container(
                    padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 3.h, bottom: 1.h),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Are You Sure You Want To Logout?",
                        style: TextStyle(
                          fontSize: 0.3.dp,
                          fontWeight: FontWeight.w700
                        ),
                        ),
                        SizedBox(width: 2.h,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () {
                                logout();
                              }, 
                              icon: Icon(Icons.check_rounded, color: Colors.green,)
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                }, 
                              icon: Icon(Icons.close, color: Colors.red,)
                            )
                          ],
                          ),
                      ],
                    )
                    ),
                ),
                                  // isDismissible: false
                  );
              },
              icon: Icon(Icons.logout),
            ),
          )
        ],
      ),
      body: Stack(
        children: [Opacity(
          opacity: Provider.of<StateManagement>(context).showPicOpacity,
          child: SingleChildScrollView(
            physics: Provider.of<StateManagement>(context).showProfilePic == true ? NeverScrollableScrollPhysics() : null,
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
                          GestureDetector(
                            onLongPress: () {
                              HapticFeedback.mediumImpact();
                              Provider.of<StateManagement>(context, listen: false).profilePicShow();
                            },
                            child: Container(
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
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onLongPress: () {
                                  HapticFeedback.mediumImpact();
                                  showModalBottomSheet(context: context, builder: (context) => SingleChildScrollView(
                                    child: Padding(
                                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                      child: Container(
                                        padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 3.h, bottom: 1.h),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextField(
                                              cursorColor: Colors.green,
                                              controller: _usernameController,
                                              maxLength: 20,
                                              decoration: InputDecoration(
                                                hintText: "Enter New Username...",
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.green),
                                                  borderRadius: BorderRadius.circular(20)
                                                ),
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.green),
                                                  borderRadius: BorderRadius.circular(20)
                                                )
                                              ),
                                              style: TextStyle(
                                                fontSize: 0.3.dp,
                                              ),
                                              onChanged: (value) {
                                                Provider.of<StateManagement>(context, listen: false).updateUserName(value);
                                              },
                                            ),
                                            SizedBox(width: 2.h,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                IconButton(
                                                  onPressed: () {
                                                    changeUserName();
                                                  }, 
                                                  icon: Icon(Icons.check_rounded, color: Colors.green,)
                                                ),
                                                IconButton(
                                                  onPressed: () { 
                                                    if(Provider.of<StateManagement>(context, listen: false).tempName != null) {
                                                      Provider.of<StateManagement>(context, listen: false).cancelUpdateUserName();
                                                    }
                                                    _usernameController.clear();
                                                    Navigator.of(context).pop();
                                                    }, 
                                                  icon: Icon(Icons.close, color: Colors.red,)
                                                )
                                              ],
                                              ),
                                          ],
                                        )
                                        ),
                                    ),
                                  ),
                                  // isDismissible: false
                                  ).whenComplete(() {
                                    if(mounted) {
                                      if(Provider.of<StateManagement>(mounted ? context : context, listen: false).tempName != null && mounted) {
                                        Provider.of<StateManagement>(mounted ? context : context, listen: false).cancelUpdateUserName();
                                      }
                                      _usernameController.clear();
                                    }
                                  });
                                },
                                child: SizedBox(
                                  width: 54.w,
                                  child: Text(
                                    Provider.of<StateManagement>(context).displayname,
                                    // minFontSize: 16,
                                    style: TextStyle(
                                      fontSize: 0.31.dp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white
                                    ),
                                    ),
                                ),
                              ),
                                Text(
                                "@${Provider.of<StateManagement>(context).username}",
                                style: TextStyle(
                                  fontSize: 0.3.dp,
                                  fontWeight: FontWeight.w600,
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
                          Text(Provider.of<StateManagement>(context).ranking == 0 ? "unranked" : Provider.of<StateManagement>(context).ranking.toString()),
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
                      log("User Posts: ${value.userPosts.isEmpty}");
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
                                if(Provider.of<StateManagement>(context, listen: false).showProfilePic) {
                                  return;
                                }
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
                                            spacing: 3.w,
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
                                                  fontSize: 0.305.dp,
                                                  fontWeight: FontWeight.bold
                                                ),
                                                )
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text(DateTimeHandler.getFormattedDate(value.userPosts[index]['dateTime']), style: TextStyle(fontSize: 0.26.dp),),
                                              Text(DateTimeHandler.getFormattedTime(value.userPosts[index]['dateTime']), style: TextStyle(fontSize: 0.26.dp),)
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
                                            Icon(value.userPosts[index]['liked'] == true ? Icons.favorite : Icons.favorite_border_rounded, color: value.userPosts[index]['liked'] == true ? Colors.red : null),
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
        ),
        if(Provider.of<StateManagement>(context).showProfilePic)...{
          Positioned(
            top: 25.h,
            left: 20.w,
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.transparent,
                  backgroundImage: imagePath == "" ? NetworkImage(Provider.of<StateManagement>(context).profilePic) : FileImage(File(imagePath)),
                  // child: Image.network(value.profilePic),
                ),
                Positioned(
                  left: 40.w,
                  child: 
                ElevatedButton(
                onPressed: () {
                  if(imagePath != "") {
                    imagePath = "";
                    setState(() {
                      
                    });
                    return;
                  }
                  Provider.of<StateManagement>(context, listen: false).profilePicHide();
                }, 
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  backgroundColor: Colors.black.withValues(alpha: 0.5),
                  padding: EdgeInsets.all(10),
                  iconSize: 0.35.dp
                ),
                child: Icon(Icons.close, color: Colors.red),
                ),),
                Positioned(
                  top: 20.h,
                  left: 40.w,
                  child: 
                ElevatedButton(
                onPressed: () {
                  if(imagePath != "") {
                    uploadImage();
                    return;
                  }
                  setImage();
                }, 
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  backgroundColor: Colors.black.withValues(alpha: 0.5),
                  padding: EdgeInsets.all(10),
                  iconSize: 0.35.dp
                ),
                child: Icon(imagePath == "" ? Icons.edit : Icons.check, color: Colors.green),
                ),)
              ]
            ),
          )
        }
        ]
      ),
    );
  }
}