import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'NotificationsScreen.dart';
import 'package:dim/widgets/ProfileScreen/MenuItemTile.dart';
import '../ViewPost/MyPostsScreen.dart';
import 'SubscriptionScreen.dart';
import 'PreferencesScreen.dart';
import 'SettingsScreen.dart';
import 'ProfileDetailInfoScreen.dart';
import 'AchievementScreen.dart';
import 'UsefulArticleScreen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _bellController;
  late Animation<double> _bellAnimation;

  late Animation<double> _profileFade;
  late Animation<double> _achievementFade;

  late List<Animation<double>> _menuItemFades;

  // Track if animations have already run once
  static bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();

    // Main controller for one-time fade/slide animations
    _mainController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Separate controller for the bell
    _bellController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Bell swinging animation
    _bellAnimation = Tween(begin: -0.05, end: 0.05).animate(
      CurvedAnimation(
        parent: _bellController,
        curve: Curves.easeInOut,
      ),
    );
    _bellController.repeat(reverse: true);

    _profileFade = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.2, curve: Curves.easeIn),
      ),
    );

    _achievementFade = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.2, 0.4, curve: Curves.easeIn),
      ),
    );

    final intervals = <Interval>[
      const Interval(0.4, 0.5, curve: Curves.easeIn),
      const Interval(0.5, 0.6, curve: Curves.easeIn),
      const Interval(0.6, 0.7, curve: Curves.easeIn),
      const Interval(0.7, 0.75, curve: Curves.easeIn),
      const Interval(0.75, 0.8, curve: Curves.easeIn),
      const Interval(0.8, 0.85, curve: Curves.easeIn),
    ];

    _menuItemFades = intervals.map((interval) {
      return Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _mainController, curve: interval),
      );
    }).toList();

    // Run main animations only once
    if (!_hasAnimated) {
      _mainController.forward().then((_) {
        _hasAnimated = true;
      });
    } else {
      // If already animated, set all values to end state
      _mainController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _mainController.dispose();
    _bellController.dispose();
    super.dispose();
  }

  void _navigateToScreen(BuildContext context, String screenName) {
    Widget screen;
    switch (screenName) {
      case 'Settings':
        screen = const SettingsScreen();
        break;
      case 'Notifications':
        screen = const NotificationsScreen();
        break;
      case 'Achievements':
        screen = const AchievementScreen();
        break;
      case 'Useful Features':
        screen = const UsefulArticleScreen();
        break;
      case 'My Profile':
        screen = const ProfileDetailInfoScreen();
        break;
      case 'Preferences':
        screen = const PreferencesScreen();
        break;
      case 'Posts':
        screen = const PostsScreen();
        break;
      case 'Subscription Management':
        screen = const SubscriptionScreen();
        break;
      default:
        screen = const ProfileScreen();
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  Widget _buildAnimatedIcon(IconData icon, Color color) {
    return Icon(icon, color: color, size: 28);
  }

  // Helper to build background decorations
  Widget _buildColoredCircle(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final menuItems = [
      MenuItemTile(
        icon: Icons.article_outlined,
        iconColor: const Color(0xFFEF9A9A),
        title: 'Useful Features',
        titleColor: Colors.pinkAccent,
        isPro: true,
        onTap: () => _navigateToScreen(context, 'Useful Features'),
      ),
      MenuItemTile(
        icon: Icons.post_add,
        iconColor: const Color(0xFF81C784),
        title: 'Posts',
        titleColor: Colors.green[600]!,
        onTap: () => _navigateToScreen(context, 'Posts'),
      ),
      MenuItemTile(
        icon: Icons.subscriptions,
        iconColor: const Color(0xFFFFB74D),
        title: 'Subscription Management',
        titleColor: Colors.amber[600]!,
        onTap: () => _navigateToScreen(context, 'Subscription Management'),
      ),
      MenuItemTile(
        icon: Icons.star_outline,
        iconColor: const Color(0xFF26A69A),
        title: 'Preferences',
        titleColor: Colors.teal[700]!,
        isPro: true,
        onTap: () => _navigateToScreen(context, 'Preferences'),
      ),
      MenuItemTile(
        icon: Icons.settings,
        iconColor: Colors.indigo[300]!,
        title: 'Settings',
        titleColor: Colors.indigo[600]!,
        onTap: () => _navigateToScreen(context, 'Settings'),
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFFFCF7),
      body: Stack(
        children: [
          //background designs
          Positioned(
            top: -30,
            left: -30,
            child: _buildColoredCircle(
                const Color(0xFF26A69A), 120), // Teal circle
          ),
          Positioned(
            top: 100,
            right: -40,
            child:
                _buildColoredCircle(const Color(0xFFEF9A9A), 80), // Pink circle
          ),
          Positioned(
            bottom: 120,
            left: -60,
            child: _buildColoredCircle(
                const Color(0xFF81C784), 140), // Green circle
          ),
          Positioned(
            bottom: 50,
            right: -30,
            child: _buildColoredCircle(
                const Color(0xFFFFB74D), 100), // Amber circle
          ),
          Positioned(
            top: 260,
            right: 100,
            child:
                _buildColoredCircle(Colors.indigo[300]!, 70), // Indigo circle
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Header with Profile text and notification icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios),
                    ),
                    const Text(
                      'Profile',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    RotationTransition(
                      turns: _bellAnimation,
                      child: IconButton(
                        icon: const Icon(
                          Icons.notifications_outlined,
                          color: Colors.black,
                        ),
                        onPressed: () =>
                            _navigateToScreen(context, 'Notifications'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // Profile image, My Profile button
                FadeTransition(
                  opacity: _profileFade,
                  child: Center(
                    child: Hero(
                      tag: 'profile-hero',
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: height*0.08, // larger size
                            backgroundImage:
                                const AssetImage('assets/images/profile.png'),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Sofia',
                            style: TextStyle(
                              fontSize: height*0.025,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          InkWell(
                            onTap: () =>
                                _navigateToScreen(context, 'My Profile'),
                            child: Text(
                              'My Profile',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: height*0.018,
                                decoration: TextDecoration
                                    .underline, // indicate it's clickable
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Achievements Card
                FadeTransition(
                  opacity: _achievementFade,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        _buildAnimatedIcon(Icons.restaurant, Colors.indigo),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Achievements',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                            ),
                            InkWell(
                              onTap: () =>
                                  _navigateToScreen(context, 'Achievements'),
                              child: Text(
                                'Review your progress',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Menu Items fade in sequentially
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ...List.generate(
                          menuItems.length,
                          (index) {
                            return FadeTransition(
                              opacity: _menuItemFades[index],
                              child: Column(
                                children: [
                                  menuItems[index],
                                  const SizedBox(height: 10),
                                ],
                              ),
                            );
                          },
                        ),
                        SizedBox(height: height / 7),
                      ],
                    ),
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
