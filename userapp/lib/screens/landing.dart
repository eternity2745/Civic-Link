import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Civic Link"),
      ),
      body: SingleChildScrollView(
        child: ListView.builder(
          itemCount: 5,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Column(
              children: [
                Container(
                height: 30.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade900
                ),
              ),
              SizedBox(height: 2.h,)
              ]
            );
          },
          ),
      ),
      );
  }
}