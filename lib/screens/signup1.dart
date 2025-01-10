import 'package:dim/screens/GetStarted.dart';
import 'package:dim/screens/PasswordField.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'HomeScreen.dart';
import 'curve.dart';
import 'login1.dart'; // Ensure this file contains BigClipper

class signup1 extends StatefulWidget {
  const signup1({super.key});

  @override
  State<signup1> createState() => _OnboardingState();
}

class _OnboardingState extends State<signup1> {
  @override
  Widget build(BuildContext context) {
    // Obtain screen dimensions inside build
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Define your onboarding pages within build to utilize screen dimensions
    final List<Widget> pages = [
      // Page 1
      Container(
        color: const Color(0xFFADD6CF),
        child: Stack(
          children: [
            // Clipped background

            ClipPath(
              clipper: BigClipper2(),
              child: Container(
                color: const Color(0xFFCBEAE5), // Background color
              ),
            ),

            ClipPath(
              clipper: SmallClipper2(),
              child: CustomPaint(
                painter: SoftPastelBackgroundPainter(),
                child: Container(),
              ),
            ),

            // Text overlay
            Center(
              child: Container(
                alignment: const Alignment(0.0, 0.0), // Center alignment
                height: screenHeight, // Full screen height
                width: screenWidth * 0.9, // Adjust width as needed
                child: SingleChildScrollView(
                  // Scroll for small screens
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center, // Align items vertically
                    crossAxisAlignment: CrossAxisAlignment
                        .start, // Align items to the start horizontally
                    children: [
                      Align(
                        alignment: const Alignment(
                            0, -0.8), // Adjust the vertical alignment as needed
                        child: Text(
                          "Signup Here",
                          style: GoogleFonts.satisfy(
                            fontSize: screenHeight / 15, // Responsive font size
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF39786D),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight / 40),
                      // First Name Field
                      TextField(
                        decoration: InputDecoration(
                          labelText: "First Name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                        ),
                      ),
                      SizedBox(
                          height: screenHeight / 40), // Space between fields

                      // Gmail Field
                      TextField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "Gmail",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                        ),
                      ),
                      SizedBox(height: screenHeight / 40),

                      // Password Field
                      const PasswordField(labelText: "Password"),
                      SizedBox(height: screenHeight / 40),

                      // Confirm Password Field
                      const PasswordField(labelText: "Confirm Password"),
                      SizedBox(height: screenHeight / 40),

                      // Occupation Type Dropdown
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: "Occupation Type",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                        ),
                        dropdownColor: const Color(0xFFC4E4E1),
                        items: ["Student", "Employee", "Self-Employed", "Other"]
                            .map((occupation) => DropdownMenuItem(
                                  value: occupation,
                                  child: Text(occupation),
                                ))
                            .toList(),
                        onChanged: (value) {
                          print("Selected Occupation: $value");
                        },
                      ),
                      SizedBox(height: screenHeight / 40),

                      // Favorite Food Type Multi-Selection

                      // Sign-Up Button
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            print("Sign Up Pressed");
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Homescreen()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 15),
                            backgroundColor:
                                const Color(0xFF000000), // Button color
                            textStyle: const TextStyle(fontSize: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          child: const Text("Sign Up"),
                        ),
                      ),
                      SizedBox(height: screenHeight / 40),
                      Align(
                        alignment: const Alignment(
                            0, -0.8), // Adjust the vertical alignment as needed
                        child: Text(
                          "Or",
                          style: GoogleFonts.roboto(
                            fontSize: screenHeight / 40, // Responsive font size
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
                            backgroundColor: Colors.white, // Button color
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
                              text: "Already have an account? ",
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 16),
                              children: [
                                TextSpan(
                                  text: "Log in",
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const login1()), // Replace with your login page
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
          // Custom background
          CustomPaint(
            painter: SoftPastelBackgroundPainter(),
            child: Container(),
          ),
          // Main content, including the AppBar
          Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent, // Make AppBar transparent
                elevation: 0, // No shadow
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back,
                      color: Colors.black), // Back button icon
                  onPressed: () {
                    Navigator.pop(context); // Go back to the previous screen
                  },
                ),
              ),
              Expanded(
                child: pages[0], // Your page content
              ),
            ],
          ),
        ],
      ),
    );
  }
}
