// page_data.dart

import 'package:flutter/material.dart';
import 'login.dart'; // Import the LoginPage
import 'signup.dart'; // Ensure About2Page is defined

class DemoPage extends StatefulWidget {
  @override
  _DemoPageState createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _buttonSlideAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize Animation Controller
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2), // Total animation duration
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

    // Start the animation automatically
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Method to handle Log In button press
  void _handleLogin() {
    // Navigate to the LoginPage
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  // Method to handle Sign Up button press
  void _handleSignUp() {
    // Implement your Sign Up logic here
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignUpPage()),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sign Up pressed')),
    );
  }

  // Method to handle Guest Mode button press
  void _handleGuestMode() {
    // Implement your Guest Mode logic here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Guest Mode pressed')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade100,
      body: Stack(
        children: [
          // Background or Centered Content
          Center(
            child: Text(
              'Welcome to the Cooking Diary!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal.shade900
              ),
            ),
          ),

          // Image 1 Animating from the Center


          // Image 2 Animating from the Center
          Center(
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Transform.translate(
                offset: Offset(150, -100), // Adjust position relative to the center
                child: Image.asset(
                  'assets/chef.gif',
                  width: 150,
                  height: 150,
                ),
              ),
            ),
          ),

          // Image 3 Animating from the Center
          Center(
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Transform.translate(
                offset: Offset(-100, 100), // Adjust position relative to the center
                child: Image.asset(
                  'assets/pot.gif',
                  width: 150,
                  height: 150,
                ),
              ),
            ),
          ),

          // Animated Buttons (Log In, Sign Up, Guest Mode)
          Positioned(
            bottom: 100,
            left: 20,
            right: 20,
            child: SlideTransition(
              position: _buttonSlideAnimation,
              child: Column(
                children: [
                  // Log In Button
                  SizedBox(
                    width: 200,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _handleLogin,
                      child: Text('Log In'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        textStyle: TextStyle(fontSize: 18),
                        backgroundColor: Colors.teal.shade500, // Button color
                        foregroundColor: Colors.white, // Text color
                      ),
                    ),
                  ),
                  SizedBox(height: 10), // Spacing between buttons

                  // Sign Up Button
                  SizedBox(
                    width: 200,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _handleSignUp,
                      child: Text('Sign Up'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        textStyle: TextStyle(fontSize: 18),
                        backgroundColor: Colors.teal.shade700, // Different color for distinction
                        foregroundColor: Colors.white, // Text/Icon color
                      ),
                    ),
                  ),
                  SizedBox(height: 10), // Spacing between buttons

                  // Guest Mode Button
                  SizedBox(
                    width: 200,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _handleGuestMode,
                      child: Text('Guest Mode'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        textStyle: TextStyle(fontSize: 18),
                        backgroundColor: Colors.teal.shade900
                        , // Different color for distinction
                        foregroundColor: Colors.white, // Text/Icon color
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
