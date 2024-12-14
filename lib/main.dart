import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dim/data/themeData.dart';
import 'package:dim/screens/HomeScreen.dart';

void main() {
  runApp(const MyApp());
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
      home: Homescreen(),
    );
  }
}
