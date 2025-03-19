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
          padding: EdgeInsets.only(top: 2.h, right: 20.w),
          child: FixedTimeline.tileBuilder(
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
              connectorStyleBuilder: (context, index) => ConnectorStyle.solidLine,
              indicatorStyleBuilder: (context, index) => IndicatorStyle.dot,
              itemCount: progress.length,
              ),
              ),
        ),
      ),
    );
  }
}