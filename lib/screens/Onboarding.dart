
import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:google_fonts/google_fonts.dart';
import 'GetStarted.dart';

import 'curve.dart'; // Ensure this file contains BigClipper

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  int currentPage = 0;
  final LiquidController _liquidController = LiquidController();

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
              clipper: BigClipper(),
              child: CustomPaint(
                painter: SoftPastelBackgroundPainter(),
                child: Container(),
              ),
            ),
            // Text overlay
            Positioned(
              top: screenHeight / 5, // Start at 1/5 of the screen height
              left: screenWidth / 20, // Align text to the left side
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome",
                    style: GoogleFonts.satisfy(
                      fontSize: screenHeight / 15, // Responsive font size
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF39786D),
                    ),
                  ),
                  Text(
                    "to",
                    style: GoogleFonts.satisfy(
                      fontSize: screenHeight / 15,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF39786D),
                    ),
                  ),
                  Text(
                    "Cooking Diary",
                    style: GoogleFonts.satisfy(
                      fontSize: screenHeight / 15,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF39786D),
                    ),
                  ),
                  Text(
                    "Show your cooking skills",
                    style: GoogleFonts.shadowsIntoLight(
                      fontSize: screenHeight / 40,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF39786D),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // Page 2
      Container(
        color: const Color(0xFFF4ECD0),
        child: Stack(
          children: [
            // Clipped background
            ClipPath(
              clipper: BigClipper(),
              child: CustomPaint(
                painter: SoftPastelBackgroundCooker(),
                child: Container(),
              ),
            ),
            // Text overlay
            Positioned(
              top: screenHeight / 5, // Start at 1/5 of the screen height
              left: screenWidth / 20, // Align text to the left side
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome",
                    style: GoogleFonts.satisfy(
                      fontSize: screenHeight / 15, // Responsive font size
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFC89A1D),
                    ),
                  ),
                  Text(
                    "to",
                    style: GoogleFonts.satisfy(
                      fontSize: screenHeight / 15,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFC89A1D),
                    ),
                  ),
                  Text(
                    "Cooking Diary",
                    style: GoogleFonts.satisfy(
                      fontSize: screenHeight / 15,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFC89A1D),
                    ),
                  ),
                  Text(
                    "Show your cooking skills",
                    style: GoogleFonts.shadowsIntoLight(
                      fontSize: screenHeight / 40,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFC89A1D),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // Page 3
      Container(
        color: const Color(0xFF84D2EF),
        child: Stack(
          children: [
            // Clipped background
            ClipPath(
              clipper: BigClipper(),
              child: CustomPaint(
                painter: SoftPastelBackgroundOrganize(),
                child: Container(),
              ),
            ),
            // Text overlay
            Positioned(
              top: screenHeight / 5, // Start at 1/5 of the screen height
              left: screenWidth / 20, // Align text to the left side
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome",
                    style: GoogleFonts.satisfy(
                      fontSize: screenHeight / 15, // Responsive font size
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2B5B88),
                    ),
                  ),
                  Text(
                    "to",
                    style: GoogleFonts.satisfy(
                      fontSize: screenHeight / 15,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2B5B88),
                    ),
                  ),
                  Text(
                    "Cooking Diary",
                    style: GoogleFonts.satisfy(
                      fontSize: screenHeight / 15,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2B5B88),
                    ),
                  ),
                  Text(
                    "Show your cooking skills",
                    style: GoogleFonts.shadowsIntoLight(
                      fontSize: screenHeight / 40,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2B5B88),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      Container(
        color: const Color(0xFFFFCDD0),
        child: Stack(
          children: [
            ClipPath(
              clipper: BigClipper(),
              child: CustomPaint(
                painter: SoftPastelBackgroundPainter(),
                child: Container(),
              ),
            ),
            Positioned(
              top: screenHeight / 5, // Start at 1/5 of the screen height
              left: screenWidth / 20, // Align text to the left side
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome",
                    style: GoogleFonts.satisfy(
                      fontSize: screenHeight / 15, // Responsive font size
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFC15F6B),
                    ),
                  ),
                  Text(
                    "to",
                    style: GoogleFonts.satisfy(
                      fontSize: screenHeight / 15,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFC15F6B),
                    ),
                  ),
                  Text(
                    "Cooking Diary",
                    style: GoogleFonts.satisfy(
                      fontSize: screenHeight / 15,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFC15F6B),
                    ),
                  ),
                  Text(
                    "Show your cooking skills",
                    style: GoogleFonts.shadowsIntoLight(
                      fontSize: screenHeight / 40,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFC15F6B),

                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: const Alignment(0, 0.85),

              child: ElevatedButton(

                onPressed: () {
                  // TODO: Implement navigation to the main app screen
                  // Example:
                  // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()));
                  print("Get Started Pressed");
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Getstarted()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 50),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  backgroundColor:
                  const Color(0xFF000000), // Button color
                  textStyle: const TextStyle(fontSize: 18),
                  iconColor: const Color(0xFFFFFFFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                    "Get Started",
                  style: TextStyle(
                    //fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ];

    return Scaffold(
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (currentPage == pages.length - 1) {
// Prevent any swipe on the last page
            return;
          } else if (details.primaryVelocity! > 0 && currentPage > 0) {
// Navigate back to the previous page on left swipe
            _liquidController.animateToPage(page: currentPage - 1);
          } else if (details.primaryVelocity! < 0 &&
              currentPage < pages.length - 1) {
// Navigate forward to the next page on right swipe
            _liquidController.animateToPage(page: currentPage + 1);
          }
        },
        child: Stack(
          children: [
            LiquidSwipe(
              pages: pages,
              enableSideReveal: false,
              enableLoop: false, // Add this line to prevent looping
              ignoreUserGestureWhileAnimating: true, // Add this to prevent gesture issues during animation
              fullTransitionValue: 300,
              slideIconWidget: currentPage == pages.length - 1
                  ? null
                  : const Icon(Icons.arrow_back_ios),
              onPageChangeCallback: (index) {
                setState(() {
                  currentPage = index;
                });
              },
              waveType: WaveType.liquidReveal,
              positionSlideIcon: 0.5,
              liquidController: _liquidController,
              disableUserGesture: currentPage == pages.length - 1, // Add this line to disable gestures on last page
            ),
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  pages.length,
                      (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    width: currentPage == index ? 12 : 8,
                    height: currentPage == index ? 12 : 8,
                    decoration: BoxDecoration(
                      color: currentPage == index
                          ? const Color(0xFF0E1514)
                          : Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
// Rest of your code remains the same
          ],
        ),
      ),
    );
  }
}



class SoftPastelBackgroundPainter extends CustomPainter {
  // Normalized positions (as fractions of width and height) and radii
  final List<Offset> normalizedPositions = [
    const Offset(0.1, 0.2),
    const Offset(0.3, 0.5),
    const Offset(0.6, 0.8),
    const Offset(0.8, 0.2),
    const Offset(0.2, 0.6),
    const Offset(0.4, 1.0),
    const Offset(0.1, 1.2),
    const Offset(0.7, 0.7),
    const Offset(0.5, 0.3),
    const Offset(1.0, 0.9),
    const Offset(0.3, 0.1),
    const Offset(0.9, 0.4),
    const Offset(0.1, 1.0),
    const Offset(0.6, 0.5),
    const Offset(0.8, 1.2),
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
    const Offset(0.1, 0.2),
    const Offset(0.3, 0.5),
    const Offset(0.6, 0.8),
    const Offset(0.8, 0.2),
    const Offset(0.2, 0.6),
    const Offset(0.4, 1.0),
    const Offset(0.7, 0.7),
    const Offset(0.5, 0.3),
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
    const Offset(0.1, 0.2),
    const Offset(0.3, 0.5),
    const Offset(0.6, 0.8),
    const Offset(0.8, 0.2),
    const Offset(0.2, 0.6),
    const Offset(0.4, 1.0),
    const Offset(0.7, 0.7),
    const Offset(0.5, 0.3),
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
    const Offset(0.1, 0.2),
    const Offset(0.3, 0.5),
    const Offset(0.6, 0.8),
    const Offset(0.8, 0.2),
    const Offset(0.2, 0.6),
    const Offset(0.4, 1.0),
    const Offset(0.7, 0.7),
    const Offset(0.5, 0.3),
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