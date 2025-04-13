import 'dart:developer';

import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
import 'package:sizer/sizer.dart';
import 'package:timelines_plus/timelines_plus.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {

  List<List<String>> progress = [
    [
      "27/03/2025",
      "4:06 PM",
      "Issued Order"
    ],
    [
      "29/03/2025",
      "7:00 AM",
      "Started Tarring Process"
    ],
    [
      "30/03/2025",
      "5:00 PM",
      "50% Tarring Completed"
    ],
    [
      "01/04/2025",
      "6:00 PM",
      "Completed Tarring Process" 
    ]
  ];

  void startAction() {
    Scaffold.of(context).showBottomSheet(
      (BuildContext context) {
        return Text("Hrllo");
      }
    );
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
      bottomNavigationBar: BottomAppBar(
        height: 8.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
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
              icon: Icon(Icons.start_rounded),
              tooltip: "Start Action",
              ),
            IconButton(
              onPressed: () {
                showModalBottomSheet(context: context, builder: (context) => Padding(
                  padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
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
                              onPressed: () {}, 
                              icon: Icon(Icons.check_rounded, color: Colors.green,)
                            ),
                            IconButton(
                              onPressed: () {}, 
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
              icon: Icon(Icons.check),
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
              icon: Icon(Icons.report_problem_outlined),
              tooltip: "Report Post",
              )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 2.h, right: 20.w),
          child: FixedTimeline.tileBuilder(
              theme: TimelineThemeData(
                color: Colors.green
              ),
              builder: TimelineTileBuilder.connectedFromStyle(
              contentsAlign: ContentsAlign.basic,
              oppositeContentsBuilder: (context, index) => Padding(
              padding: EdgeInsets.all(2.h),
              child: Text('${progress[index][0]}\n${progress[index][1]}'),
              ),
              contentsBuilder: (context, index) => Padding(
              padding: EdgeInsets.all(2.h),
              child: Text(progress[index][2],
                          style: TextStyle(
                            fontSize: 0.3.dp
                          ),
                          ),
              ),
              lastConnectorStyle: ConnectorStyle.transparent,
              firstConnectorStyle: ConnectorStyle.transparent,
              connectorStyleBuilder: (context, index) { 
                return index == progress.length-2 ? ConnectorStyle.dashedLine : ConnectorStyle.solidLine;
                },
              indicatorStyleBuilder: (context, index) { 
                return index == progress.length-1 ? IndicatorStyle.outlined : IndicatorStyle.dot;
                },
              itemCount: progress.length,
              ),
              ),
        ),
      ),
    );
  }
}