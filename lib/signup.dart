// signup.dart

import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with TickerProviderStateMixin { // Changed from SingleTickerProviderStateMixin
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _buttonSlideAnimation;

  // New AnimationController and Animation for Circular Reveal
  late AnimationController _revealController;
  late Animation<double> _revealAnimation;

  // New AnimationController and Animation for Shaking
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  // New color to reveal
  final Color _newBackgroundColor = Colors.green.shade100; // Desired blue color

  // To track if the reveal is completed
  bool _revealCompleted = false;

  // Manage the current background color
  Color _currentBackgroundColor = Colors.white; // Start with white

  @override
  void initState() {
    super.initState();

    // Initialize Animation Controller for scaling and sliding
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1), // Total animation duration
    );

    // Scale Animation for Images (0.0 to 1.0)
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Slide Animation for Buttons (from bottom to original position)
    _buttonSlideAnimation = Tween<Offset>(
      begin: Offset(0, 1), // Start below the screen
      end: Offset(0, 0),   // End at the original position
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Start the existing animations
    _controller.forward();

    // Initialize Animation Controller for Circular Reveal
    _revealController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800), // Duration for the reveal
    );

    // Define the animation for the circle's radius
    _revealAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _revealController, curve: Curves.easeOut),
    );

    // Listen to the animation status to set the reveal completed flag
    _revealAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _currentBackgroundColor = _newBackgroundColor; // Update background to blue
          _revealCompleted = true; // Remove the overlay
        });
      }
    });

    // Start the circular reveal immediately without delay
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _revealController.forward();
    });

    // Initialize Animation Controller for Shaking
    _shakeController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500), // Duration for the shake
    );

    // Define the shaking animation: oscillate between -10 and 10 pixels on the X-axis
    _shakeAnimation = Tween<double>(begin: -10.0, end: 10.0).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );

    // Start the shaking animation
    _shakeController.forward();

    // Optionally, repeat the shaking animation if desired
    // _shakeController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    _revealController.dispose(); // Dispose the reveal controller
    _shakeController.dispose();  // Dispose the shake controller
    super.dispose();
  }

  // Method to handle Sign Up action
  void _handleSignUp() {
    // Implement your sign-up logic here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sign Up completed!')),
    );
  }

  // Method to handle Back to Login action
  void _handleBackToLogin() {
    Navigator.pop(context); // Go back to the previous page
  }

  @override
  Widget build(BuildContext context) {
    // Calculate the maximum radius needed to cover the screen from the center
    double maxRadius = MediaQuery.of(context).size.longestSide * 1.5;

    return Scaffold(
      body: Stack(
        children: [
          // Base Background Color
          Container(
            color: _currentBackgroundColor, // Use the current background color
            width: double.infinity,
            height: double.infinity,
          ),

          // Circular Reveal Animation Overlay
          if (!_revealCompleted)
            AnimatedBuilder(
              animation: _revealAnimation,
              builder: (context, child) {
                double radius = _revealAnimation.value * maxRadius;
                return ClipPath(
                  clipper: CircleClipper(
                    radius: radius,
                    center: Alignment.center,
                  ),
                  child: Container(
                    color: _newBackgroundColor, // Blue color to reveal
                    width: double.infinity,
                    height: double.infinity,
                  ),
                );
              },
            ),

          // Background or Centered Content
          Center(
            child: Text(
              'Create Your Account',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),

          // Animated Images with Shaking Effect
          Center(
            child: AnimatedBuilder(
              animation: _shakeAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(_shakeAnimation.value, 0), // Shakes horizontally
                  child: child,
                );
              },
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Transform.translate(
                  offset: Offset(0, -100),
                  child: Image.asset(
                    'assets/signup1.gif',
                    width: 150,
                    height: 150,
                  ),
                ),
              ),
            ),
          ),


          // Form and Buttons
          Positioned(
            bottom: 100,
            left: 20,
            right: 20,
            child: SlideTransition(
              position: _buttonSlideAnimation,
              child: Column(
                children: [
                  // Name TextField with consistent size
                  SizedBox(
                    width: 350, // Set a consistent width
                    height: 40, // Set a consistent height
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10, // Reduce vertical padding
                          horizontal: 10, // Reduce horizontal padding
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  // Email TextField with consistent size
                  SizedBox(
                    width: 350, // Set a consistent width
                    height: 40, // Set a consistent height
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10, // Reduce vertical padding
                          horizontal: 10, // Reduce horizontal padding
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  // Password TextField with consistent size
                  SizedBox(
                    width: 350, // Set a consistent width
                    height: 40, // Set a consistent height
                    child: TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10, // Reduce vertical padding
                          horizontal: 10, // Reduce horizontal padding
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Sign Up Button with consistent style
                  SizedBox(
                    width: 200, // Match the width from LoginPage
                    child: ElevatedButton(
                      onPressed: _handleSignUp,
                      child: Text('Sign Up'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        textStyle: TextStyle(fontSize: 18),
                        backgroundColor: Colors.green.shade300, // Match LoginPage color
                        foregroundColor: Colors.black, // Match LoginPage text color
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  // Back to Login Button with consistent style
                  SizedBox(
                    width: 200, // Match the width from LoginPage
                    child: ElevatedButton(
                      onPressed: _handleBackToLogin,
                      child: Text('Back to Login'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        textStyle: TextStyle(fontSize: 18),
                        backgroundColor: Colors.green.shade400, // Match LoginPage color
                        foregroundColor: Colors.black, // Match LoginPage text color
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Clipper to define the circular reveal area
class CircleClipper extends CustomClipper<Path> {
  final double radius;
  final Alignment center;

  CircleClipper({required this.radius, required this.center});

  @override
  Path getClip(Size size) {
    // Calculate the center point based on alignment
    Offset centerPoint = Offset(
      size.width * (center.x + 1) / 2,
      size.height * (center.y + 1) / 2,
    );

    return Path()..addOval(Rect.fromCircle(center: centerPoint, radius: radius));
  }

  @override
  bool shouldReclip(CircleClipper oldClipper) {
    return radius != oldClipper.radius || center != oldClipper.center;
  }
}
