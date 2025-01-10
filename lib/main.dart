import 'package:dim/screens/HomeScreen.dart';
import 'package:dim/screens/Profile/PaymentMethodsScreen.dart';
import 'package:dim/screens/Profile/SubscriptionScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'firebase_options.dart';
import 'package:dim/screens/ViewPost/MyPostsScreen.dart';
import '/screens/Onboarding.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/data/themeData.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Supabase.initialize(
    url: 'https://ftxynincmxoriezkggdi.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ0eHluaW5jbXhvcmllemtnZ2RpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzYxMzk2MTgsImV4cCI6MjA1MTcxNTYxOH0.78nIJvy_EjK0N_qL2lQQYNXDxIIJ2GuOuT30aTXp8jc',
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
      home: Onboarding() ,
      //home: SubscriptionScreen(),
      //home: Homescreen(),
    );
  }
}
