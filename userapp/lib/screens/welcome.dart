import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:sizer/sizer.dart';
import 'package:userapp/Screens/login.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
        pages: [
          PageViewModel(
            title: "Welcome to Civic Link",
            body: "Building a better future together",
            image: Image.asset("assets/Civic Link.png"),
            decoration: const PageDecoration(
              pageColor: Colors.black,
              titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              bodyTextStyle: TextStyle(fontSize: 16),
            ),
          ),
          PageViewModel(
            title: "Connect with your community",
            body: "Stay updated issues in and around your locality",
            image: Center(child: Image.asset("assets/Civic Link.png")),
            decoration: const PageDecoration(
              pageColor: Colors.black,
              titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              bodyTextStyle: TextStyle(fontSize: 16),
            ),
          ),
          PageViewModel(
            title: "Post Issues",
            body: "Post issues about water, electricity, roads, etc in your locality",
            image: Center(child: Image.asset("assets/Civic Link.png")),
            decoration: const PageDecoration(
              pageColor: Colors.black,
              titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              bodyTextStyle: TextStyle(fontSize: 16),
            ),
          ),
          PageViewModel(
            title: "Notify The Authorities",
            body: "Notify the authorities about the issues in your locality and see the real time progress of these issues",
            image: Center(child: Image.asset("assets/Civic Link.png")),
            decoration: const PageDecoration(
              pageColor: Colors.black,
              titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              bodyTextStyle: TextStyle(fontSize: 16),
            ),
          ),
        ],
        dotsDecorator: DotsDecorator(
          color: Colors.white38,
          activeColor: Colors.green
        ),
        done: Text("Get Started", style: TextStyle(color: Colors.green, fontSize: 0.27.dp),),
        onDone: () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
        },
        skip: Icon(Icons.double_arrow_rounded, color: Colors.green, size: 0.35.dp,),
        onSkip: () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
        },
        showSkipButton: true,
        next: Icon(Icons.arrow_forward, color: Colors.green, size: 0.35.dp,),
      ),
    );
  }
}