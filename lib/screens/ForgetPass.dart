// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:dim/data/constants.dart';
import 'package:dim/screens/GetStarted.dart';
import 'package:dim/screens/GoogleAuth.dart';
import 'package:dim/screens/SignUp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'HomeScreen.dart';
import 'PasswordField.dart';
import 'curve.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'curve.dart'; // Import the same curve/clipping file you used for LogIn

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  void _sendOTP() {
    // Logic to send OTP to email
    print("OTP sent to ${emailController.text.trim()}");
    _showSnackBar("OTP sent to your email.");
  }

  void _resetPassword() {
    final email = emailController.text.trim();
    final otp = otpController.text.trim();
    final newPassword = newPasswordController.text.trim();

    if (email.isEmpty || otp.isEmpty || newPassword.isEmpty) {
      _showSnackBar("Please fill all fields.");
      return;
    }

    // Logic to verify OTP and reset the password
    print("Password reset for $email with new password: $newPassword");
    _showSnackBar("Password reset successful.");
    Navigator.pop(context); // Navigate back after successful reset
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
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
            painter: SoftPastelBackgroundPainter(), // Custom background painter
            child: Container(),
          ),
          Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: _buildForm(screenHeight, screenWidth),
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
        icon: Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildForm(double screenHeight, double screenWidth) {
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
          clipper: BigClipper2(), // Use your custom clipper here
          child: Container(color: const Color(0xFFCBEAE5)),
        ),
        ClipPath(
          clipper: SmallClipper2(), // Use another custom clipper
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
        _buildTextField("Enter OTP", otpController),
        SizedBox(height: screenHeight / 40),
        _buildTextField("New Password", newPasswordController, isPassword: true),
        SizedBox(height: screenHeight / 20),
        _buildResetButton(),
      ],
    );
  }

  Widget _buildHeader(double screenHeight) {
    return Align(
      alignment: Alignment(0, -0.8),
      child: Text(
        "Forgot Password",
        style: GoogleFonts.satisfy(
          fontSize: screenHeight / 15,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF39786D),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool isEmail = false, bool isPassword = false}) {
    return TextField(
      controller: controller,
      keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
    );
  }

  Widget _buildResetButton() {
    return Center(
      child: ElevatedButton(
        onPressed: _resetPassword,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          backgroundColor: const Color(0xFF39786D),
          textStyle: const TextStyle(fontSize: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        ),
        child: const Text(
          "Reset Password",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
