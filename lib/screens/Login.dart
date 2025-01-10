// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:dim/screens/AddPost/fetchRecipes.dart';
import 'package:dim/screens/GetStarted.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'HomeScreen.dart';
import 'PasswordField.dart';
import 'SignUpOld.dart';
import 'curve.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser =
        await GoogleSignIn.standard().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  // Future<firebase_auth.User?> _signInWithGoogle() async {
  //   try {
  //     // Trigger the Google Authentication flow
  //     final GoogleSignInAccount? googleUser =
  //         await GoogleSignIn.standard().signIn();

  //     if (googleUser == null) {
  //       // User canceled the sign-in
  //       return null;
  //     }

  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser.authentication;

  //     // Create a new credential
  //     final OAuthCredential credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );

  //     // Sign in with Firebase
  //     final UserCredential userCredential =
  //         await _auth.signInWithCredential(credential);
  //     return userCredential.user;
  //   } catch (e) {
  //     print("Error signing in with Google: $e");
  //     return null;
  //   }
  // }

  void _navigateToHome() {
    fetchRecipes();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Homescreen()),
    );
  }

  void _navigateToSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignUp()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          CustomPaint(
            painter: SoftPastelBackgroundPainter(),
            child: Container(),
          ),
          Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: _buildLogInForm(screenHeight, screenWidth),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildLogInForm(double screenHeight, double screenWidth) {
    return Container(
      color: const Color(0xFFADD6CF),
      child: Stack(
        children: [
          _buildBackground(),
          Center(
            child: Container(
              alignment: Alignment(0.0, 0.0),
              height: screenHeight,
              width: screenWidth * 0.9,
              child: SingleChildScrollView(
                child: _buildFormContent(screenHeight),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Stack(
      children: [
        ClipPath(
          clipper: BigClipper2(),
          child: Container(color: const Color(0xFFCBEAE5)),
        ),
        ClipPath(
          clipper: SmallClipper2(),
          child: CustomPaint(
            painter: SoftPastelBackgroundPainter(),
            child: Container(),
          ),
        ),
      ],
    );
  }

  Widget _buildFormContent(double screenHeight) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(screenHeight),
        SizedBox(height: screenHeight / 40),
        _buildTextField("Email", emailController, isEmail: true),
        SizedBox(height: screenHeight / 40),
        PasswordField(labelText: "Password", controller: passwordController),
        SizedBox(height: screenHeight / 40),
        _buildLogInButton(),
        SizedBox(height: screenHeight / 40),
        _buildOrDivider(screenHeight),
        SizedBox(height: screenHeight / 40),
        _buildGoogleButton(),
        SizedBox(height: screenHeight / 40),
        _buildSignUpPrompt(),
      ],
    );
  }

  Widget _buildHeader(double screenHeight) {
    return Align(
      alignment: Alignment(0, -0.8),
      child: Text(
        "Login Here",
        style: GoogleFonts.satisfy(
          fontSize: screenHeight / 15,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF39786D),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool isEmail = false}) {
    return TextField(
      controller: controller,
      keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
    );
  }

  Widget _buildLogInButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          final String email = emailController.text.trim();
          final String password = passwordController.text.trim();

          if (email.isEmpty || password.isEmpty) {
            // Show an error message
            _showSnackBar('Please enter both email and password');
            return;
          }

          try {
            // Sign in with Firebase

            UserCredential userCredential = await FirebaseAuth.instance
                .signInWithEmailAndPassword(email: email, password: password);
            // Supabase login
            AuthResponse supabaseResponse =
                await Supabase.instance.client.auth.signInWithPassword(
              email: email,
              password: password,
            );
            print(supabaseResponse);
            print(userCredential);
            // Navigate to the home screen on successful login
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Homescreen()),
            );
          } catch (e) {
            // Show error message on failure
            _showSnackBar('Login failed: ${e.toString()}');
          }
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          backgroundColor: const Color(0xFF39786D),
          textStyle: const TextStyle(fontSize: 18),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        ),
        child: const Text(
          "Log in",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildOrDivider(double screenHeight) {
    return Align(
      alignment: Alignment(0, -0.8),
      child: Text(
        "Or",
        style: GoogleFonts.roboto(
          fontSize: screenHeight / 40,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF39786D),
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget _buildGoogleButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          try {
            // Sign in with Google using Firebase
            UserCredential user = await signInWithGoogle();
            print(user);

            // Show a snackbar on error
            if (user.user == null) {
              _showSnackBar("Error signing in with Google");
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
              'display_name': displayName,
              'photo_url': photoUrl,
            });

            

            // Navigate to the home screen on successful login
            if (firebaseUid.isNotEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Homescreen()),
              );
            }
          } catch (e) {
            // Handle any errors
            print(e);
            _showSnackBar("Error signing in with Google: ${e.toString()}");
          }
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          backgroundColor: Colors.white,
          textStyle: const TextStyle(fontSize: 18),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
        ),
        child: const Text("🇬 Continue with Google"),
      ),
    );
  }

  Widget _buildSignUpPrompt() {
    return Padding(
      padding: const EdgeInsets.only(top: 0.0),
      child: Center(
        child: RichText(
          text: TextSpan(
            text: "Don't have an account? ",
            style: TextStyle(color: Colors.black, fontSize: 16),
            children: [
              TextSpan(
                text: "Sign Up",
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()..onTap = _navigateToSignUp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
