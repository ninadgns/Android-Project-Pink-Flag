import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:google_fonts/google_fonts.dart';

import 'HomeScreen.dart';
import 'curve.dart';
import 'login1.dart'; // Ensure this file contains BigClipper

class signup1 extends StatefulWidget {
  const signup1({Key? key}) : super(key: key);

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
                alignment: Alignment(0.0, 0.0), // Center alignment
                height: screenHeight, // Full screen height
                width: screenWidth * 0.9, // Adjust width as needed
                child: SingleChildScrollView( // Scroll for small screens
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // Align items vertically
                    crossAxisAlignment: CrossAxisAlignment.start, // Align items to the start horizontally
                    children: [

                      Align(
                        alignment: Alignment(0, -0.8), // Adjust the vertical alignment as needed
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
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        ),
                      ),
                      SizedBox(height: screenHeight / 40), // Space between fields

                      // Gmail Field
                      TextField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "Gmail",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        ),
                      ),
                      SizedBox(height: screenHeight / 40),

                      // Password Field
                      PasswordField(labelText: "Password"),
                      SizedBox(height: screenHeight / 40),

                      // Confirm Password Field
                      PasswordField(labelText: "Confirm Password"),
                      SizedBox(height: screenHeight / 40),

                      // Occupation Type Dropdown
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: "Occupation Type",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
                              MaterialPageRoute(builder: (context) => Homescreen()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                            backgroundColor: const Color(0xFF39786D),  // Button color
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
                        alignment: Alignment(0, -0.8), // Adjust the vertical alignment as needed
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
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
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
                              style: TextStyle(color: Colors.black, fontSize: 16),
                              children: [
                                TextSpan(
                                  text: "Log in",
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => login1()), // Replace with your login page
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
                  icon: const Icon(Icons.arrow_back, color: Colors.black), // Back button icon
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

class PasswordField extends StatefulWidget {
  final String labelText;

  const PasswordField({Key? key, required this.labelText}) : super(key: key);

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}


class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: _obscureText,
      decoration: InputDecoration(
        labelText: widget.labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      ),
    );
  }
}




class SoftPastelBackgroundPainter extends CustomPainter {
  // Normalized positions (as fractions of width and height) and radii
  final List<Offset> normalizedPositions = [
    Offset(0.1, 0.2),
    Offset(0.3, 0.5),
    Offset(0.6, 0.8),
    Offset(0.8, 0.2),
    Offset(0.2, 0.6),
    Offset(0.4, 1.0),
    Offset(0.1, 1.2),
    Offset(0.7, 0.7),
    Offset(0.5, 0.3),
    Offset(1.0, 0.9),
    Offset(0.3, 0.1),
    Offset(0.9, 0.4),
    Offset(0.1, 1.0),
    Offset(0.6, 0.5),
    Offset(0.8, 1.2),
  ];

  final List<double> normalizedRadii = [
    0.1, 0.22, 0.09, 0.41, 0.08, 0.13, 0.1, 0.08, 0.51, 0.12, 0.09, 0.1, 0.08, 0.13, 0.21,
  ];

  @override
  void paint(Canvas canvas, Size size) {
    // Step 1: Draw the background color
    final backgroundPaint =
    Paint()..color = const Color(0xfffaf6f2); // Soft background color
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);

    // Step 2: Define a list of pastel colors
    final colors = [
      const Color(0xFFADD6CF).withOpacity(0.15), // Pastel Blue
      const Color(0xFFF0AF9E).withOpacity(0.15), // Pastel Pink
      const Color(0xFFFFD59A).withOpacity(0.15), // Pastel Yellow
      const Color(0xFFC3B1E1).withOpacity(0.15), // Pastel Purple
    ];

    // Step 3: Create paint objects for each color
    final paints = colors.map((color) => Paint()..color = color).toList();

    // Step 4: Draw circles using normalized values
    for (int i = 0; i < normalizedPositions.length; i++) {
      // Scale normalized position to screen size
      final position = Offset(
        normalizedPositions[i].dx * size.width,
        normalizedPositions[i].dy * size.height,
      );

      // Scale normalized radius to screen size
      final radius = normalizedRadii[i] * size.width; // Assuming radius scales with width

      // Randomize color
      final paint = paints[i % paints.length];

      // Draw the circle
      canvas.drawCircle(position, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


class SoftPastelBackgroundCooker extends CustomPainter {
  // Normalized positions (as fractions of width and height) and sizes
  final List<Offset> normalizedPositions = [
    Offset(0.1, 0.2),
    Offset(0.3, 0.5),
    Offset(0.6, 0.8),
    Offset(0.8, 0.2),
    Offset(0.2, 0.6),
    Offset(0.4, 1.0),
    Offset(0.7, 0.7),
    Offset(0.5, 0.3),
  ];

  final List<double> normalizedSizes = [
    0.1, 0.12, 0.09, 0.11, 0.08, 0.13, 0.1, 0.08,
  ];

  @override
  void paint(Canvas canvas, Size size) {
    // Step 1: Draw the background color
    final backgroundPaint =
    Paint()..color = const Color(0xfffaf6f2); // Soft background color
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);

    // Step 2: Define a list of pastel colors
    final colors = [
      const Color(0xFFADD6CF).withOpacity(0.3), // Pastel Blue
      const Color(0xFFF0AF9E).withOpacity(0.3), // Pastel Pink
      const Color(0xFFFFD59A).withOpacity(0.3), // Pastel Yellow
      const Color(0xFFC3B1E1).withOpacity(0.3), // Pastel Purple
    ];

    // Step 3: Define a list of icons
    final icons = [
      Icons.star,
      Icons.favorite,
      Icons.home,
      Icons.accessibility,
      Icons.flash_on,
    ];

    // Step 4: Draw icons based on normalized values
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    for (int i = 0; i < normalizedPositions.length; i++) {
      // Scale normalized position to screen size
      final position = Offset(
        normalizedPositions[i].dx * size.width,
        normalizedPositions[i].dy * size.height,
      );

      // Scale normalized size to screen size
      final iconSize = normalizedSizes[i] * size.width; // Size scales with screen width

      // Randomize color and icon
      final color = colors[i % colors.length];
      final icon = icons[i % icons.length];

      // Prepare icon as text
      textPainter.text = TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontSize: iconSize,
          fontFamily: icon.fontFamily,
          color: color,
        ),
      );

      textPainter.layout();
      textPainter.paint(canvas, position);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class SoftPastelBackgroundOrganize extends CustomPainter {
  // Normalized positions (as fractions of width and height) and sizes
  final List<Offset> normalizedPositions = [
    Offset(0.1, 0.2),
    Offset(0.3, 0.5),
    Offset(0.6, 0.8),
    Offset(0.8, 0.2),
    Offset(0.2, 0.6),
    Offset(0.4, 1.0),
    Offset(0.7, 0.7),
    Offset(0.5, 0.3),
  ];

  final List<double> normalizedSizes = [
    0.1, 0.12, 0.09, 0.11, 0.08, 0.13, 0.1, 0.08,
  ];

  @override
  void paint(Canvas canvas, Size size) {
    // Step 1: Draw the background color
    final backgroundPaint =
    Paint()..color = const Color(0xffd7edf8); // Soft background color
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);

    // Step 2: Define a list of pastel colors
    final colors = [
      const Color(0xFFADD6CF).withOpacity(0.3), // Pastel Blue
      const Color(0xFFF0AF9E).withOpacity(0.3), // Pastel Pink
      const Color(0xFFFFD59A).withOpacity(0.3), // Pastel Yellow
      const Color(0xFFC3B1E1).withOpacity(0.3), // Pastel Purple
    ];

    // Step 3: Define a list of icons
    final icons = [
      Icons.star,
      Icons.favorite,
      Icons.home,
      Icons.accessibility,
      Icons.flash_on,
    ];

    // Step 4: Draw icons based on normalized values
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    for (int i = 0; i < normalizedPositions.length; i++) {
      // Scale normalized position to screen size
      final position = Offset(
        normalizedPositions[i].dx * size.width,
        normalizedPositions[i].dy * size.height,
      );

      // Scale normalized size to screen size
      final iconSize = normalizedSizes[i] * size.width; // Size scales with screen width

      // Randomize color and icon
      final color = colors[i % colors.length];
      final icon = icons[i % icons.length];

      // Prepare icon as text
      textPainter.text = TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontSize: iconSize,
          fontFamily: icon.fontFamily,
          color: color,
        ),
      );

      textPainter.layout();
      textPainter.paint(canvas, position);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class SoftPastelBackgroundCommunity extends CustomPainter {
  // Normalized positions (as fractions of width and height) and sizes
  final List<Offset> normalizedPositions = [
    Offset(0.1, 0.2),
    Offset(0.3, 0.5),
    Offset(0.6, 0.8),
    Offset(0.8, 0.2),
    Offset(0.2, 0.6),
    Offset(0.4, 1.0),
    Offset(0.7, 0.7),
    Offset(0.5, 0.3),
  ];

  final List<double> normalizedSizes = [
    0.1, 0.12, 0.09, 0.11, 0.08, 0.13, 0.1, 0.08,
  ];

  @override
  void paint(Canvas canvas, Size size) {
    // Step 1: Draw the background color
    final backgroundPaint =
    Paint()..color = const Color(0xfff8d7dc); // Soft background color
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);

    // Step 2: Define a list of pastel colors
    final colors = [
      const Color(0xFFADD6CF).withOpacity(0.3), // Pastel Blue
      const Color(0xFFF0AF9E).withOpacity(0.3), // Pastel Pink
      const Color(0xFFFFD59A).withOpacity(0.3), // Pastel Yellow
      const Color(0xFFC3B1E1).withOpacity(0.3), // Pastel Purple
    ];

    // Step 3: Define a list of icons
    final icons = [
      Icons.star,
      Icons.favorite,
      Icons.home,
      Icons.accessibility,
      Icons.flash_on,
    ];

    // Step 4: Draw icons based on normalized values
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    for (int i = 0; i < normalizedPositions.length; i++) {
      // Scale normalized position to screen size
      final position = Offset(
        normalizedPositions[i].dx * size.width,
        normalizedPositions[i].dy * size.height,
      );

      // Scale normalized size to screen size
      final iconSize = normalizedSizes[i] * size.width; // Size scales with screen width

      // Randomize color and icon
      final color = colors[i % colors.length];
      final icon = icons[i % icons.length];

      // Prepare icon as text
      textPainter.text = TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontSize: iconSize,
          fontFamily: icon.fontFamily,
          color: color,
        ),
      );

      textPainter.layout();
      textPainter.paint(canvas, position);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}