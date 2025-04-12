import 'package:authorityapp/Screens/login.dart';
import 'package:authorityapp/Utilities/state.dart';
import 'package:authorityapp/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await RiveFile.initialize();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => StateManagement(),
      child: Sizer(
        builder: (p0, p1, p2) {
          return MaterialApp(
            title: 'Civic Authority',
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
      ),
    );
  }
}