import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'package:sizer/sizer.dart';
import 'package:userapp/screens/home.dart';
import 'package:userapp/screens/login.dart';
import 'package:userapp/screens/post.dart';

void main() {
  
  WidgetsFlutterBinding.ensureInitialized();
  RiveFile.initialize();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.black.withOpacity(0.002)
    ),
  );
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp
    ]
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, screenType) {
      return MaterialApp(
        title: 'Civic Link',
        darkTheme: ThemeData.dark(),
        // highContrastDarkTheme: ThemeData.dark(),
        theme: ThemeData(

          // primaryColor: Colors.green.shade900,
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: const LoginScreen(),
        );
      }
    );
  }
}

