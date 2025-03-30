import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:sizer/sizer.dart';
import 'package:userapp/Screens/login.dart';
import 'package:userapp/Utilities/state.dart';
import 'package:userapp/firebase_options.dart';

Future main() async {
  await DotEnv().load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  RiveFile.initialize();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
    return ChangeNotifierProvider(
      create: (context) => StateManagement(),
      child: Sizer(builder: (context, orientation, screenType) {
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
      ),
    );
  }
}

