import 'dart:math';

import 'package:flutter/material.dart';
import 'login1.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:google_fonts/google_fonts.dart';

import 'curve.dart'; // Ensure this file contains BigClipper
import 'signup1.dart';

class Getstarted extends StatefulWidget {
  const Getstarted({Key? key}) : super(key: key);

  @override
  State<Getstarted> createState() => _OnboardingState();
}

class _OnboardingState extends State<Getstarted> {

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

            Align(
              alignment: Alignment(0, 0.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight / 8),

                  Text(
                    "Welcome Here",
                    style: GoogleFonts.satisfy(
                      fontSize: screenHeight / 12, // Responsive font size
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF39786D),
                    ),
                  ),
                  Text(
                    "Show your cooking skills, cook like a pro, join with community",
                    style: GoogleFonts.shadowsIntoLight(
                      fontSize: screenHeight / 40,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF39786D),
                    ),
                  ),
                ],
              ),
            ),    // Text overlay
            // Align(
            //   alignment: Alignment(0,1000),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Text(
            //         "Welcome Here",
            //         style: GoogleFonts.satisfy(
            //           fontSize: screenHeight / 12, // Responsive font size
            //           fontWeight: FontWeight.bold,
            //           color: const Color(0xFF39786D),
            //         ),
            //       ),
            //
            //
            //       Text(
            //         textAlign: TextAlign.center,
            //         "Show your cooking skills, cook like a pro, join with community",
            //         style: GoogleFonts.shadowsIntoLight(
            //           fontSize: screenHeight / 40,
            //           fontWeight: FontWeight.bold,
            //           color: const Color(0xFF39786D),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            Center(
              child: Container(
                alignment: Alignment(0.0, 0.5),
                height: screenHeight, // Full screen height
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // Align buttons vertically
                  children: [
                    // First Button
                    ElevatedButton(
                      child: const Text("SignUp"),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => signup1()), // Navigate to signup1 screen
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth / 15, // 1/15th of screen width
                          vertical: 20,
                        ),
                        backgroundColor: const Color(0xFFADD6CE), // Button color
                        textStyle: const TextStyle(fontSize: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),


                    ),
                    SizedBox(height: screenHeight / 40), // Vertical space between buttons

                    // Second Button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => login1()), // Navigate to signup1 screen
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth / 15, // 1/15th of screen width
                          vertical: 20,
                        ),
                        backgroundColor:  const Color(0xFF7AACA5), // Button color
                        textStyle: const TextStyle(fontSize: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: const Text("Login"),
                    ),
                    SizedBox(height: screenHeight / 40), // Vertical space between buttons

                    // Third Button
                    ElevatedButton(
                      onPressed: () {
                        print("Button 3 Pressed");
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth / 15, // 1/15th of screen width
                          vertical: 20,
                        ),
                        backgroundColor: const Color(0xFF39786D), // Button color
                        textStyle: const TextStyle(fontSize: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: const Text("Guest"),
                    ),
                  ],
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