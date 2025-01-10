// ignore_for_file: prefer_const_constructors

import 'package:dim/screens/AddPost/fetchRecipes.dart';
import 'package:dim/screens/GetStarted.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'HomeScreen.dart';
import 'PasswordField.dart';
import 'SignUpOld.dart';
import 'curve.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _OnboardingState();
}

class _OnboardingState extends State<LogIn> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    final List<Widget> pages = [
      Container(
        color: const Color(0xFFADD6CF),
        child: Stack(
          children: [
            ClipPath(
              clipper: BigClipper2(),
              child: Container(
                color: const Color(0xFFCBEAE5),
              ),
            ),
            ClipPath(
              clipper: SmallClipper2(),
              child: CustomPaint(
                painter: SoftPastelBackgroundPainter(),
                child: Container(),
              ),
            ),
            Center(
              child: Container(
                alignment: Alignment(0.0, 0.0),
                height: screenHeight,
                width: screenWidth * 0.9,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment(0, -0.8),
                        child: Text(
                          "Login Here",
                          style: GoogleFonts.satisfy(
                            fontSize: screenHeight / 15,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF39786D),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight / 40),
                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "Email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                        ),
                      ),
                      SizedBox(height: screenHeight / 40),
                      PasswordField(
                        labelText: "Password",
                        controller: passwordController,
                      ),
                      SizedBox(height: screenHeight / 40),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            fetchRecipes();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Homescreen()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 15),
                            backgroundColor: const Color(0xFF39786D),
                            textStyle: const TextStyle(fontSize: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          child: const Text(
                            "Log in",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight / 40),
                      Align(
                        alignment: Alignment(0, -0.8),
                        child: Text(
                          "Or",
                          style: GoogleFonts.roboto(
                            fontSize: screenHeight / 40,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF39786D),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight / 40),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            print("Google Pressed");
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 15),
                            backgroundColor: Colors.white,
                            textStyle: const TextStyle(fontSize: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0.0),
                            ),
                          ),
                          child: const Text("🇬 Continue with Google"),
                        ),
                      ),
                      SizedBox(height: screenHeight / 40),
                      Padding(
                        padding: const EdgeInsets.only(top: 0.0),
                        child: Center(
                          child: RichText(
                            text: TextSpan(
                              text: "Don't have an account? ",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                              children: [
                                TextSpan(
                                  text: "Sign Up",
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => SignUp()),
                                      );
                                    },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ];

    return Scaffold(
      body: Stack(
        children: [
          CustomPaint(
            painter: SoftPastelBackgroundPainter(),
            child: Container(),
          ),
          Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Expanded(
                child: pages[0],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
