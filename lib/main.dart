import 'package:dim/screens/HomeScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import '/screens/Onboarding.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/data/themeData.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Set the system UI overlay style
    // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    //   statusBarColor: Colors.transparent, // Make the status bar transparent
    //   statusBarIconBrightness: Brightness.dark, // Dark icons for light background
    //   statusBarBrightness: Brightness.light, // Light status bar for iOS
    // ));
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: appTheme,
      home: Onboarding(),
      //home: Homescreen(),
    );
  }
}
