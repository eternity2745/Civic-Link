import 'dart:developer';

import 'package:authorityapp/Database/methods.dart';
import 'package:authorityapp/Utilities/dateTimeHandler.dart';
import 'package:authorityapp/Utilities/state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_animate/flutter_animate.dart';
import 'package:sizer/sizer.dart';
import 'package:timelines_plus/timelines_plus.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {

  final TextEditingController _progressController = TextEditingController();

  void startAction(String postID) async {
    Timestamp time = Timestamp.now();
    bool result = await DatabaseMethods().startAction(postID, time);
    if(result && mounted) {
      Provider.of<StateManagement>(context, listen: false).startAction(time);
      IconSnackBar.show(
              context,
              label: "Issue Order Successfully",
              snackBarType: SnackBarType.success,
              labelTextStyle: TextStyle(color: Colors.white)
            );
    }else{
      if(mounted){
        IconSnackBar.show(
                context,
                label: "Failed in Issuing Order! Try Again!!",
                snackBarType: SnackBarType.fail,
                labelTextStyle: TextStyle(color: Colors.white)
              );
      }
    }
  }

  void addProgress(String postID) async {
    if(_progressController.text.isEmpty) {
      return;
    }
    Timestamp time = Timestamp.now();
    bool result = await DatabaseMethods().addProgress(postID, time, _progressController.text);
    if(result && mounted) {
      Provider.of<StateManagement>(context, listen: false).addProgress(time, _progressController.text);
      IconSnackBar.show(
              context,
              label: "Issue Order Successfully",
              snackBarType: SnackBarType.success,
              labelTextStyle: TextStyle(color: Colors.white)
            );
      Navigator.of(context).pop();
    }else{
      if(mounted){
        IconSnackBar.show(
                context,
                label: "Failed in Issuing Order! Try Again!!",
                snackBarType: SnackBarType.fail,
                labelTextStyle: TextStyle(color: Colors.white)
              );
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Text(
          "Issue Progress",
          style: TextStyle(
            fontSize: 0.4.dp,
            fontWeight: FontWeight.bold
          ),
          ),
      ),
      bottomNavigationBar: Consumer<StateManagement>(
        builder: (context, value, child) {
        return BottomAppBar(
          height: 8.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  if (value.mainPosts![value.mainPostID]["action"] == true) {
                    IconSnackBar.show(
                      context,
                      label: "Action Already Taken",
                      snackBarType: SnackBarType.fail,
                      labelTextStyle: TextStyle(color: Colors.white)
                    );
                  } else {
                    showModalBottomSheet(context: context, builder: (context) => Container(
                      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Issued Order?",
                            style: TextStyle(
                              fontSize: 0.3.dp,
                            ),
                          ),
                          SizedBox(width: 3.w,),
                          IconButton(
                            onPressed: () {
                              startAction(value.mainPosts![value.mainPostID]['postID']);
                              Navigator.of(context).pop();
                            }, 
                            icon: Icon(Icons.check_rounded, color: Colors.green,)
                          ),
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(), 
                            icon: Icon(Icons.close, color: Colors.red,)
                          )
                        ],
                      ),
                    ),
                    backgroundColor: Colors.grey.shade800,
                    constraints: BoxConstraints(
                      minHeight: 5.h,
                      minWidth: 100.w
                    ),
                    isScrollControlled: true,
                    useSafeArea: true
                    );
                  }
                }, 
                icon: Icon(Icons.start_rounded, color: value.mainPosts![value.mainPostID]["action"] == true ? Colors.green : null,),
                tooltip: "Start Action",
                ),
              IconButton(
                onPressed: () {
                  if(value.mainPosts![value.mainPostID]["action"] == false) {
                    IconSnackBar.show(
                      context,
                      label: "Please Start Action First",
                      snackBarType: SnackBarType.fail,
                      labelTextStyle: TextStyle(color: Colors.white)
                    );
                    return;
                  }
                  if(value.mainPosts![value.mainPostID]["completed"] == true) {
                    IconSnackBar.show(
                      context,
                      label: "Issue Already Completed",
                      snackBarType: SnackBarType.fail,
                      labelTextStyle: TextStyle(color: Colors.white)
                    );
                    return;
                  }
                  showModalBottomSheet(context: context, builder: (context) => Padding(
                    padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: _progressController,
                            minLines: 1,
                            maxLines: 4,
                            decoration: InputDecoration(
                              hintText: "Update Progress...",
                              prefixIcon: Icon(Icons.create),
                              border: InputBorder.none,
                            ),
                            cursorColor: Colors.green,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {
                                  addProgress(value.mainPosts![value.mainPostID]['postID']);
                                }, 
                                icon: Icon(Icons.check_rounded, color: Colors.green,)
                              ),
                              IconButton(
                                onPressed: () => Navigator.of(context).pop(), 
                                icon: Icon(Icons.close, color: Colors.red,)
                              )
                          ],
                          )
                        ],
                      ),
                    ),
                  ),
                  backgroundColor: Colors.grey.shade800,
                  constraints: BoxConstraints(
                    minHeight: 5.h,
                    minWidth: 100.w
                  ),
                  isScrollControlled: true,
                  useSafeArea: true
                  );
                }, 
                icon: Icon(Icons.add_rounded),
                tooltip: "Add Progress",
                ),
              IconButton(
                onPressed: () {
                  showModalBottomSheet(context: context, builder: (context) => Container(
                    padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Mark As Complete?",
                          style: TextStyle(
                            fontSize: 0.3.dp,
                          ),
                        ),
                        SizedBox(width: 3.w,),
                        IconButton(
                          onPressed: () {}, 
                          icon: Icon(Icons.check_rounded, color: Colors.green,)
                        ),
                        IconButton(
                          onPressed: () {}, 
                          icon: Icon(Icons.close, color: Colors.red,)
                        )
                      ],
                    ),
                  ),
                  backgroundColor: Colors.grey.shade800,
                  constraints: BoxConstraints(
                    minHeight: 5.h,
                    minWidth: 100.w
                  ),
                  isScrollControlled: true,
                  useSafeArea: true
                  );
                }, 
                icon: Icon(Icons.check, color: value.isCompleted ? Colors.green : null,),
                tooltip: "Mark As Completed",
                ),
              IconButton(
                onPressed: () {
                  showModalBottomSheet(context: context, builder: (context) => Container(
                    padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Report Post?",
                          style: TextStyle(
                            fontSize: 0.3.dp,
                          ),
                        ),
                        SizedBox(width: 3.w,),
                        IconButton(
                          onPressed: () {}, 
                          icon: Icon(Icons.check_rounded, color: Colors.green,)
                        ),
                        IconButton(
                          onPressed: () {}, 
                          icon: Icon(Icons.close, color: Colors.red,)
                        )
                      ],
                    ),
                  ),
                  backgroundColor: Colors.grey.shade800,
                  constraints: BoxConstraints(
                    minHeight: 5.h,
                    minWidth: 100.w
                  ),
                  isScrollControlled: true,
                  useSafeArea: true
                  );
                }, 
                icon: Icon(Icons.report_problem_outlined, color: value.isReported ? Colors.green : null,),
                tooltip: "Report Post",
                )
            ],
          ),
        );
        }
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 2.h, right: 20.w),
          child: Consumer<StateManagement>(
            builder: (context, value, child) {
            return FixedTimeline.tileBuilder(
                theme: TimelineThemeData(
                  color: value.mainPosts![value.mainPostID]["action"] == false ? Colors.red : Colors.green
                ),
                builder: TimelineTileBuilder.connectedFromStyle(
                contentsAlign: ContentsAlign.basic,
                oppositeContentsBuilder: (context, index) => Padding(
                padding: EdgeInsets.all(2.h),
                child: value.mainPosts![value.mainPostID]["action"] == false ? Text("")
                :
                Text('${DateTimeHandler.getFormattedDate(value.mainPosts![value.mainPostID]["progress"][index]["progContent"][0])}\n${DateTimeHandler.getFormattedTime(value.mainPosts![value.mainPostID]["progress"][index]["progContent"][0])}'),
                ),
                contentsBuilder: (context, index) => Padding(
                padding: EdgeInsets.all(2.h),
                child: value.mainPosts![value.mainPostID]["action"] == false ? Text("No Action Taken", style: TextStyle(
                              fontSize: 0.3.dp
                            ),) : 
                Text(value.mainPosts![value.mainPostID]["progress"][index]["progContent"][1],
                            style: TextStyle(
                              fontSize: 0.3.dp
                            ),
                            ),
                ),
                lastConnectorStyle: value.mainPosts![value.mainPostID]["completed"]==false ? ConnectorStyle.dashedLine : ConnectorStyle.transparent,
                firstConnectorStyle: ConnectorStyle.transparent,
                connectorStyleBuilder: (context, index) { 
                  return ConnectorStyle.solidLine;
                  },
                indicatorStyleBuilder: (context, index) { 
                  return value.mainPosts![value.mainPostID]["action"]==false ? IndicatorStyle.outlined : IndicatorStyle.dot;
                  },
                itemCount: value.mainPosts![value.mainPostID]["progress"].length == 0 ? 1 : value.mainPosts![value.mainPostID]["progress"].length,
                ),
              );
            }
          ),
        ),
      ),
    );
  }
}