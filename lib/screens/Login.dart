// Login.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dim/data/themeData.dart';
import 'package:dim/screens/HomeScreen.dart';

import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with TickerProviderStateMixin { // Changed from SingleTickerProviderStateMixin
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _buttonSlideAnimation;

  // New AnimationController and Animation for Circular Reveal
  late AnimationController _revealController;
  late Animation<double> _revealAnimation;

  // New color to reveal
  final Color _newBackgroundColor = Colors.lime.shade50; // Desired blue color

  // To track if the reveal is completed
  bool _revealCompleted = false;

  // Manage the current background color
  Color _currentBackgroundColor = Colors.teal.shade100; // Start with white

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
      end: Offset(0, 0), // End at the original position
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
  }

  @override
  void dispose() {
    _controller.dispose();
    _revealController.dispose(); // Dispose the new controller
    super.dispose();
  }

  // Method to handle Login action
  void _handleLogin() {
    // Show a SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Logged In successfully!')),
    );

    // Navigate to the HomeScreen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Homescreen()),
    );
  }


  // Method to handle Forgot Password action
  void _handleForgotPassword() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Forgot Password clicked!')),
    );
  }

  // Method to handle Back to Sign Up action
  void _handleBackToSignUp() {
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
              'Welcome Back!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),

          // Animated Images (example placeholders)
          Center(
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Transform.translate(
                offset: Offset(0, -100),
                child: Image.asset(
                  'assets/login.gif',
                  width: 100,
                  height: 100,
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
                  // Email TextField with reduced size
                  SizedBox(
                    width: 350, // Set a smaller width
                    height: 40, // Set a smaller height
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

                  // Password TextField with reduced size
                  SizedBox(
                    width: 350, // Set a smaller width
                    height: 40, // Set a smaller height
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

                  // Log In Button
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: _handleLogin,
                      child: Text('Log In'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        textStyle: TextStyle(fontSize: 18),
                        backgroundColor: Colors.lime.shade500,
                        foregroundColor: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  // Forgot Password Button
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: _handleForgotPassword,
                      child: Text('Forget password?'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        textStyle: TextStyle(fontSize: 18),
                        backgroundColor: Colors.lime.shade400,
                        foregroundColor: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  // Back to Sign Up Button
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: _handleBackToSignUp,
                      child: Text('Back to Signup'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        textStyle: TextStyle(fontSize: 18),
                        backgroundColor: Colors.lime.shade300,
                        foregroundColor: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
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