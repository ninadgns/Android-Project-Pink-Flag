// ignore_for_file: prefer_const_constructors
import 'package:dim/screens/GetStarted.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'HomeScreen.dart';
import 'LogInOld.dart';
import 'PasswordField.dart';
import 'curve.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  // Controllers for user input
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  // Navigation method for Sign Up button
  void _navigateToHome() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Homescreen()),
    );
  }

  // Navigation method for Log In button
  void _navigateToLogIn() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LogIn()),
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
                child: _buildSignUpForm(screenHeight, screenWidth),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // App bar widget
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

  // Main form widget
  Widget _buildSignUpForm(double screenHeight, double screenWidth) {
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

  // Background widget
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

  // Form content widget
  Widget _buildFormContent(double screenHeight) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(screenHeight),
        SizedBox(height: screenHeight / 40),
        _buildTextField("Name", nameController),
        SizedBox(height: screenHeight / 40),
        _buildTextField("Email", emailController, isEmail: true),
        SizedBox(height: screenHeight / 40),
        PasswordField(labelText: "Password", controller: passwordController),
        SizedBox(height: screenHeight / 40),
        PasswordField(
            labelText: "Confirm Password",
            controller: confirmPasswordController),
        SizedBox(height: screenHeight / 40),
        _buildSignUpButton(),
        SizedBox(height: screenHeight / 40),
        _buildOrDivider(screenHeight),
        SizedBox(height: screenHeight / 40),
        _buildGoogleButton(),
        SizedBox(height: screenHeight / 40),
        _buildLogInPrompt(),
      ],
    );
  }

  // Header widget
  Widget _buildHeader(double screenHeight) {
    return Align(
      alignment: Alignment(0, -0.8),
      child: Text(
        "Signup Here",
        style: GoogleFonts.satisfy(
          fontSize: screenHeight / 15,
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

  void _signUpWithEmailAndPassword() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();
    String name = nameController.text.trim();

    // Input validation
    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      _showSnackBar("Please fill in all fields");
      return;
    }

    if (password != confirmPassword) {
      _showSnackBar("Passwords do not match");
      return;
    }

    try {
      // Create a new user with Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // Optionally update the display name
      await userCredential.user?.updateDisplayName(name);

      // Navigate to HomeScreen on success
      _navigateToHome();
    } catch (e) {
      // Handle sign-up errors
      _showSnackBar("Sign-Up failed: ${e.toString()}");
    }
  }

  // Text field widget
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

  // Sign-up button widget
  Widget _buildSignUpButton() {
    return Center(
      child: ElevatedButton(
        onPressed: _signUpWithEmailAndPassword,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          backgroundColor: const Color(0xFF39786D),
          textStyle: const TextStyle(fontSize: 18),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        ),
        child: const Text(
          "Sign Up",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  // Divider widget
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

  // Google button widget
  Widget _buildGoogleButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () => print("Google Pressed"),
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

  // Log-in prompt widget
  Widget _buildLogInPrompt() {
    return Padding(
      padding: const EdgeInsets.only(top: 0.0),
      child: Center(
        child: RichText(
          text: TextSpan(
            text: "Already have an account? ",
            style: TextStyle(color: Colors.black, fontSize: 16),
            children: [
              TextSpan(
                text: "Log in",
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()..onTap = _navigateToLogIn,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
