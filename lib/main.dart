import 'package:flutter/material.dart';
import 'start.dart'; // Ensure this file exists and DemoPage is defined
import 'page_data.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Circular Reveal Transition',
      home: ImageAnimationScreen(),
      debugShowCheckedModeBanner: false, // Removes the debug banner
    );
  }
}

class ImageAnimationScreen extends StatefulWidget {
  @override
  _ImageAnimationScreenState createState() => _ImageAnimationScreenState();
}

class _ImageAnimationScreenState extends State<ImageAnimationScreen>
    with TickerProviderStateMixin {
  // Animation Controller for Circular Reveal
  late AnimationController _colorController;
  late Animation<double> _radiusAnimation;

  // Current and New Colors
  int _currentPage = 0;
  final int _totalPages = 4;
  final List<Color> _pageColors = [
    Colors.amber.shade100, // Page 1
    Colors.teal.shade100, // Page 2
    Colors.green.shade100, // Page 3
    Colors.red.shade50 // Page 4
  ];
  Color _currentColor = Colors.white;
  Color _newColor = Colors.white;

  @override
  void initState() {
    super.initState();

    // Initialize Animation Controller for Circular Reveal
    _colorController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800), // Duration for the color transition
    );

    // Define the animation for the circle's radius
    _radiusAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _colorController, curve: Curves.easeOut),
    );

    // Listen to the animation status to update the background color once the animation completes
    _colorController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _currentColor = _newColor;
        });
        _colorController.reset();
      }
    });

    // Start the initial background color transition
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _changeBackgroundColor(_pageColors[_currentPage]);
    });
  }

  @override
  void dispose() {
    _colorController.dispose();
    super.dispose();
  }

  String _getDescription() {
    return pageData[_currentPage].description;
  }

  // Method to trigger the circular reveal transition
  void _changeBackgroundColor(Color newColor) {
    setState(() {
      _newColor = newColor;
    });
    _colorController.forward();
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      setState(() {
        _currentPage++;
      });
      Color targetColor = _pageColors[_currentPage];
      _changeBackgroundColor(targetColor);
    } else {
      // Navigate to the next screen (e.g., DemoPage)
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DemoPage()),
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
      });
      Color targetColor = _pageColors[_currentPage];
      _changeBackgroundColor(targetColor);
    }
  }

  void _skipToLastPage() {
    setState(() {
      _currentPage = _totalPages - 1;
    });
    Color targetColor = _pageColors[_currentPage];
    _changeBackgroundColor(targetColor);
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
            color: _currentColor,
            width: double.infinity,
            height: double.infinity,
          ),

          // AnimatedBuilder for the circular reveal transition
          AnimatedBuilder(
            animation: _radiusAnimation,
            builder: (context, child) {
              return (_colorController.isAnimating)
                  ? ClipOval(
                clipper: CircleClipper(
                  radius: _radiusAnimation.value * maxRadius,
                  center: Alignment.center,
                ),
                child: Container(
                  color: _newColor,
                  width: double.infinity,
                  height: double.infinity,
                ),
              )
                  : SizedBox.shrink();
            },
          ),

          // Main Content
          SafeArea(
            child: Stack(
              children: [
                // Centered Content: Page Number and Description
                Positioned.fill(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        pageData[_currentPage].title,
                        style: TextStyle(
                          fontSize: pageData[_currentPage].titleFontSize,
                          fontWeight: FontWeight.bold,
                          color: pageData[_currentPage].titleColor,
                        ),
                      ),


                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          _getDescription(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: pageData[_currentPage].descriptionFontSize,
                            color: pageData[_currentPage].descriptionColor,
                          ),
                        ),
                      ),

                    ],
                  ),
                ),

                // Image Animations based on the current page using AnimatedSwitcher

                // Image 1: Top-Left Corner
                Align(
                  alignment: Alignment(0.5, 0.5), // Moves the child up by 50% of the available space
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 800),
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return ScaleTransition(scale: animation, child: child);
                    },
                    child: _currentPage == 0
                        ? Image.asset(
                      'assets/image16.gif',
                      key: ValueKey<int>(_currentPage),
                      width: 200,
                      height: 200,
                    )
                        : SizedBox.shrink(),
                  ),
                ),



                Align(
                  alignment: Alignment(0.0, -0.5),
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 800),
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return ScaleTransition(scale: animation, child: child);
                    },
                    child: _currentPage == 0
                        ? Image.asset(
                      'assets/image10.png',
                      key: ValueKey<int>(_currentPage),
                      width: 200,
                      height: 200,
                    )
                        : SizedBox.shrink(),
                  ),
                ),


                // Image 2: Bottom-Right Corner
                Positioned(
                  bottom: 200,
                  right: 200,
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 800),
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return ScaleTransition(scale: animation, child: child);
                    },
                    child: _currentPage == 1
                        ? Image.asset(
                      'assets/image7.png',
                      key: ValueKey<int>(_currentPage),
                      width: 100,
                      height: 100,
                    )
                        : SizedBox.shrink(),
                  ),
                ),

                // Image 3: Center-Left
                Align(
                  alignment: Alignment(-.5, -0.25),
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 800),
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return ScaleTransition(scale: animation, child: child);
                    },
                    child: _currentPage == 2
                        ? Image.asset(
                      'assets/image4.png',
                      key: ValueKey<int>(_currentPage),
                      width: 120,
                      height: 120,
                    )
                        : SizedBox.shrink(),
                  ),
                ),

                // Image 4: Center-Right
                Align(
                  alignment: Alignment(0.7, 0),
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 800),
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return ScaleTransition(scale: animation, child: child);
                    },
                    child: _currentPage == 3
                        ? Image.asset(
                      'assets/shoppinglist.gif',
                      key: ValueKey<int>(_currentPage),
                      width: 100,
                      height: 100,
                    )
                        : SizedBox.shrink(),
                  ),
                ),

                // Back Button in the top-left corner
                Positioned(
                  top: 20,
                  left: 10,
                  child: Visibility(
                    visible: _currentPage > 0, // Hide back button on the first page
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.black, size: 28),
                      onPressed: _previousPage,
                    ),
                  ),
                ),

                // Circular Progress Button and Skip Button at the bottom
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Circular Progress Button
                      GestureDetector(
                        onTap: _nextPage,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 80,
                              height: 80,
                              child: CircularProgressIndicator(
                                value: (_currentPage + 1) / _totalPages, // Progress value
                                backgroundColor: Colors.grey.shade300,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                                strokeWidth: 6,
                              ),
                            ),
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black,
                              ),
                              child: Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 10),

                      // Skip Button
                      TextButton(
                        onPressed: _skipToLastPage,
                        child: Text(
                          "Skip",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Clipper to define the circular reveal area
class CircleClipper extends CustomClipper<Rect> {
  final double radius;
  final Alignment center;

  CircleClipper({required this.radius, required this.center});

  @override
  Rect getClip(Size size) {
    // Calculate the center point based on alignment
    Offset centerPoint = Offset(
      size.width * (center.x + 1) / 2,
      size.height * (center.y + 1) / 2,
    );

    return Rect.fromCircle(center: centerPoint, radius: radius);
  }

  @override
  bool shouldReclip(CircleClipper oldClipper) {
    return radius != oldClipper.radius || center != oldClipper.center;
  }
}
