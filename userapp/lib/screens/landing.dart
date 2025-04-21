import 'dart:developer';
import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart' as flutter_animate;
import 'package:geocoding/geocoding.dart' as g;
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:userapp/Database/methods.dart';
import 'package:userapp/Screens/post.dart';
import 'package:userapp/Utilities/dateTimeHandler.dart';
import 'package:userapp/Utilities/descriptionTrimmer.dart';
import 'package:userapp/Utilities/state.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {

  @override
  bool get wantKeepAlive => true;

  final TextEditingController filterController = TextEditingController();
  late final AnimationController _loadAnimationController;

  late LocationData locationData;

  void getPosts() async {
    QuerySnapshot posts = await DatabaseMethods().getMainPosts();
    HapticFeedback.mediumImpact();
    if(mounted) {
      Provider.of<StateManagement>(context, listen: false).setCollectionState(posts);
    }
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
      HapticFeedback.mediumImpact();
      Provider.of<StateManagement>(context, listen: false).setPosts(mainPosts);
      // Navigator.push(context, MaterialPageRoute(builder: ((context) => PostScreen())));
    }
    
  }

  void filterPosts() async {
    HapticFeedback.mediumImpact();
    Provider.of<StateManagement>(context, listen: false).setReachedEnd(false);
    log(filterController.text);
    Provider.of<StateManagement>(context, listen: false).filterPosts();
    if(filterController.text == "In My Locality") {
      String locality = "";
      locality = await currentLocation();
      if(locality == "") {
        log(locality);
        if(mounted) {
          Provider.of<StateManagement>(context, listen: false).setPosts([]);
          // Navigator.push(context, MaterialPageRoute(builder: ((context) => PostScreen())));
        }
      }else{
        QuerySnapshot posts = await DatabaseMethods().getLocalityPosts(locality);
        HapticFeedback.mediumImpact();
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
          HapticFeedback.mediumImpact();
          Provider.of<StateManagement>(context, listen: false).setPosts(mainPosts);
          // Navigator.push(context, MaterialPageRoute(builder: ((context) => PostScreen())));
        }
      }
    }else if(filterController.text == "Near My Location") {
      List<double> locationData = await currentLocation();
      await DatabaseMethods().getNearLocationPosts(locationData[0], locationData[1]);
    }else{
      getPosts();
    }
  }   

  Future currentLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    Location location = Location();
    serviceEnabled = await location.serviceEnabled();
    log("$serviceEnabled");
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return "";
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return "";
      }
    }

    locationData = await location.getLocation();
    // return [locationData.latitude!, locationData.longitude!];
    var addresses = await g.GeocodingPlatform.instance!.placemarkFromCoordinates(
          locationData.latitude!, locationData.longitude!
          );
      var first = addresses.first;
      // log("$addresses");
      if (mounted) {
      String? locality = first.subAdministrativeArea != "" ? first.subAdministrativeArea : first.subLocality != "" ? first.subLocality : first.locality != "" ? first.locality : first.administrativeArea;
      return locality;
    }
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

  void loadMore(Map<String, dynamic> lastDoc) async {
    _loadAnimationController.forward();
    QuerySnapshot posts = await DatabaseMethods().getNextPosts(Provider.of<StateManagement>(context, listen: false).collectionState!);
    if(mounted) {
      Provider.of<StateManagement>(context, listen: false).setCollectionState(posts);
    }
    List<Map<String, dynamic>> mainPosts = [];
    int i = 0;

    if(posts.docs.isEmpty && mounted) {
      Provider.of<StateManagement>(context, listen: false).setReachedEnd(true);
      _loadAnimationController.reset();
      return;
    }
    
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
      _loadAnimationController.reset();
      Provider.of<StateManagement>(context, listen: false).addMainPosts(mainPosts);
      // Navigator.push(context, MaterialPageRoute(builder: ((context) => PostScreen())));
    }
  }

  @override
  void initState() {
    getPosts();
    _loadAnimationController = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    filterController.dispose();
    _loadAnimationController.dispose();
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
                    padding: EdgeInsets.only(top: 1.h),
                    child: CustomMaterialIndicator(
              onRefresh: () async {
              Provider.of<StateManagement>(context, listen: false).mainPostsisLoading();
              if(filterController.text == "In My Locality") {
                filterPosts();
              }else{
                getPosts();
              }
              Provider.of<StateManagement>(context, listen: false).mainPostsisLoading();
            },
            indicatorBuilder: (context, controller) {
              return Image.asset("assets/Civic Link.png", fit: BoxFit.cover,).animate(
                onPlay: (control){
                  control.repeat();
                },
                effects: [
                  flutter_animate.RotateEffect(
                    duration: 7.seconds,
                    curve: Curves.linear,
                    begin: 0.0,
                    end: math.pi * 2,
                  ),
                  flutter_animate.ScaleEffect(
                    duration: 0.5.seconds,
                    curve: Curves.linear,
                    begin: Offset(0, 0),
                    end: Offset(1, 1),
                  )
                ],
              );
            },
            backgroundColor: Color(int.parse('0xffECE3CE')),
            autoRebuild: false,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 3.w,),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  "Filter Posts",
                                  style: TextStyle(
                                    fontSize: 0.32.dp
                                  ),
                                  ),
                                DropdownMenu(
                                  inputDecorationTheme: InputDecorationTheme(
                                    constraints: BoxConstraints(
                                      maxHeight: 6.5.h,
                                      maxWidth: 70.w
                                    ),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))
                                  ),
                                  initialSelection: Text("All"),
                                  hintText: "Select Filter",
                                  onSelected: (value) {
                                    filterPosts();
                                  },
                                  controller: filterController,
                                  dropdownMenuEntries: [
                                  DropdownMenuEntry(value: Text("All"), label: "All"),
                                  DropdownMenuEntry(value: Text("In My Locality"), label: "In My Locality")
                                ])
                              ],
                            ),
                          ),
                          SizedBox(height: 1.h,),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Consumer<StateManagement>(
                                builder: (context, value, child) {
                                if(value.mainPosts!.isEmpty) {
                                  return Padding(
                                    padding: EdgeInsets.only(left: 2.w, top: 12.h),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset("assets/Civic Link.png", fit: BoxFit.cover, height: 30.h, width: 35.w,),
                                        Text("No Posts Found", style: TextStyle(
                                          fontSize: 0.4.dp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey.shade400
                                        ),)
                                      ],
                                    ),
                                    );
                                }
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
                                                HapticFeedback.mediumImpact();
                                                Provider.of<StateManagement>(context, listen: false).commentsLoading = true;
                                                Provider.of<StateManagement>(context, listen: false).mainPostID = index;
                                                Provider.of<StateManagement>(context, listen: false).userPostsID = -1;
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
                                                                fontSize: 0.305.dp,
                                                                fontWeight: FontWeight.bold
                                                              ),
                                                              )
                                                          ],
                                                        ),
                                                        Column(
                                                          children: [
                                                            Text(value.mainPostsLoading ? "" : DateTimeHandler.getFormattedDate(value.mainPosts![index]['dateTime']), style: TextStyle(fontSize: 0.26.dp),),
                                                            Text(value.mainPostsLoading ? "" : DateTimeHandler.getFormattedTime(value.mainPosts![index]['dateTime']), style: TextStyle(fontSize: 0.26.dp),)
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
                                            if(index == value.mainPosts!.length - 1 && value.reachedEnd == false && filterController.text != "In My Locality")...{
                                              Divider(thickness: 0.8,),
                                              Center(child: IconButton(
                                                onPressed: () {
                                                  loadMore(value.mainPosts![value.mainPosts!.length - 1]);
                                                }, icon: Icon(
                                                  Icons.add_circle_outline_rounded, 
                                                  color: Colors.grey.shade600,
                                                  ),
                                                  iconSize: 0.5.dp,
                                                ).animate(
                                                  autoPlay: false,
                                                  controller: _loadAnimationController,
                                                  onPlay: (controller) => controller.repeat(),
                                                  effects: [
                                                    flutter_animate.RotateEffect(
                                                      duration: 1.seconds
                                                    )
                                                  ]
                                                ),
                                              )
                                            }else if(index == value.mainPosts!.length - 1 && value.reachedEnd == true && filterController.text != "In My Locality")...{
                                              Divider(thickness: 0.8,),
                                              Center(
                                                child: Text(
                                                  "You've Reached The End",
                                                  style: TextStyle(
                                                    fontSize: 0.3.dp,
                                                    color: Colors.grey.shade600
                                                  ),
                                                ),
                                              ),
                                            SizedBox(height: 1.h,)
                                            }else...{
                                              Divider(thickness: 0.8,)
                                            }
                                            ]
                                          ),
                                        );
                                      },
                                      )
                                  );
                                }
                              ),
                            ),
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