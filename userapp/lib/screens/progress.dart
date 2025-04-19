import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_animate/flutter_animate.dart';
import 'package:sizer/sizer.dart';
import 'package:timelines_plus/timelines_plus.dart';
import 'package:userapp/Utilities/dateTimeHandler.dart';
import 'package:userapp/Utilities/state.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {

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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 2.h, right: 20.w, bottom: 4.h),
          child: Consumer<StateManagement>(
            builder: (context, value, child) {
            List<Map<String, dynamic>>? posts = [];
            int postID = 0;
            if(value.mainPostID == -1) {
              posts = value.userPosts;
              postID = value.userPostsID;
            }else{
              posts = value.mainPosts!;
              postID = value.mainPostID;
            }
            return FixedTimeline.tileBuilder(
                theme: TimelineThemeData(
                  color: posts[postID]["action"] == false ? Colors.red : Colors.green
                ),
                builder: TimelineTileBuilder.connectedFromStyle(
                contentsAlign: ContentsAlign.basic,
                oppositeContentsBuilder: (context, index) => Padding(
                padding: EdgeInsets.all(2.h),
                child: posts![postID]["action"] == false ? Text("")
                :
                Text('${DateTimeHandler.getFormattedDate(posts[postID]["progress"][index]["progContent"][0])}\n${DateTimeHandler.getFormattedTime(posts[postID]["progress"][index]["progContent"][0])}'),
                ),
                contentsBuilder: (context, index) => Padding(
                padding: EdgeInsets.all(2.h),
                child: posts![postID]["action"] == false ? Text("No Action Taken", style: TextStyle(
                              fontSize: 0.3.dp
                            ),) : 
                Text(posts[postID]["progress"][index]["progContent"][1],
                            style: TextStyle(
                              fontSize: 0.3.dp
                            ),
                            ),
                ),
                lastConnectorStyle: posts[postID]["completed"]==false ? ConnectorStyle.dashedLine : ConnectorStyle.transparent,
                firstConnectorStyle: ConnectorStyle.transparent,
                connectorStyleBuilder: (context, index) { 
                  return ConnectorStyle.solidLine;
                  },
                indicatorStyleBuilder: (context, index) { 
                  return posts![postID]["action"]==false ? IndicatorStyle.outlined : IndicatorStyle.dot;
                  },
                itemCount: posts[postID]["progress"].length == 0 ? 1 : posts[postID]["progress"].length,
                ),
              );
            }
          ),
        ),
      ),
    );
  }
}