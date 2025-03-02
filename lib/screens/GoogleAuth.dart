// File: google_sign_in.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'HomeScreen.dart';

/// This function handles Google Sign-In and navigation to home screen.
Future<void> handleGoogleSignIn(
    BuildContext context, Function(String) showSnackBar) async {
  try {
    // Sign in with Google using Firebase
    UserCredential user = await signInWithGoogle();

    // Show a snackbar on error
    if (user.user == null) {
      showSnackBar("Error signing in with Google");
      return;
    }

    // Extract user details
    String firebaseUid = user.user?.uid ?? '';
    String email = user.user?.email ?? '';
    String displayName = user.user?.displayName ?? '';
    String photoUrl = user.user?.photoURL ?? '';

    // Insert or update user in the Supabase users table
    final supabase = Supabase.instance.client;
    final response = await supabase.from('users').upsert({
      'id': firebaseUid, // Firebase UID as the unique identifier
      'email': email,
      'full_name': displayName,
      'photo_url': photoUrl,
    }, ignoreDuplicates: true);

    // Navigate to the home screen on successful login
    if (firebaseUid.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Homescreen()),
      );
    }
  } catch (e) {
    // Handle any errors
    print(e);
    showSnackBar("Error signing in with Google: ${e.toString()}");
  }
}

/// This function handles Google Sign-In and returns a [UserCredential].
Future<UserCredential> signInWithGoogle() async {
  try {
    // Create a GoogleSignIn instance
    final GoogleSignIn googleSignIn = GoogleSignIn.standard();

    // Sign out any existing user to prompt the account selection dialog
    await googleSignIn.signOut();

    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser =
        await GoogleSignIn.standard().signIn();

    // Check if the sign-in was successful
    if (googleUser == null) {
      throw Exception('Google sign-in was cancelled');
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  } catch (e) {
    // Handle sign-in errors
    throw Exception('Failed to sign in with Google: $e');
  }
}
