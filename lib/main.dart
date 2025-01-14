import 'package:dim/screens/HomeScreen.dart';
import 'package:dim/screens/Login.dart';
import 'package:dim/services/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '/data/themeData.dart';
import '/screens/Onboarding.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeFirebase();
  await Supabase.initialize(
    url: 'https://ftxynincmxoriezkggdi.supabase.co',
    anonKey:
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ0eHluaW5jbXhvcmllemtnZ2RpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzYxMzk2MTgsImV4cCI6MjA1MTcxNTYxOH0.78nIJvy_EjK0N_qL2lQQYNXDxIIJ2GuOuT30aTXp8jc',
  );

  runApp(
    ChangeNotifierProvider(
        create: (context) => UserProvider()..fetchCurrentUser(),
        child: const MyApp()),
  );
}

Future<void> _initializeFirebase() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    if (e.toString().contains('duplicate-app')) {
      // Firebase app already initialized, do nothing
    } else {
      rethrow;
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dim',
      theme: appTheme,
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<auth.User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasData) {
          return const Homescreen();
        } else {
          return const Onboarding();
        }
      },
    );
  }
}