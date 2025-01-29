import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../Onboarding.dart';
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
  final String imagePath;

  const ProfileScreen({super.key, required this.imagePath});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _bellController;
  late Animation<double> _bellAnimation;
  late Animation<double> _profileFade;
  late List<Animation<double>> _menuItemFades;
  static bool _hasAnimated = false;
  String userName = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _initializeAnimations();
  }

  Future<void> _loadUserData() async {
    try {
      final String? uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        final response = await Supabase.instance.client
            .from('users')
            .select('full_name')
            .eq('id', uid)
            .single();

        if (mounted) {
          setState(() {
            userName = response['full_name'] ?? '';
          });
        }
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  Future<void> _onRefresh() async {
    await _loadUserData();
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text('Logout',
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(color: Colors.black, fontWeight: FontWeight.bold)),
        title: Text('Logout',
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(color: Colors.black, fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
            ),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const Onboarding()),
                (Route<dynamic> route) => false,
              );
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _initializeAnimations() {
    _mainController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _bellController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

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

    if (!_hasAnimated) {
      _mainController.forward().then((_) {
        _hasAnimated = true;
      });
    } else {
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
      case 'Useful Features':
        screen = const UsefulArticleScreen();
        break;
      case 'My Profile':
        screen = ProfileDetailInfoScreen(imagePath: widget.imagePath);
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
        screen = ProfileScreen(imagePath: widget.imagePath);
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  Widget _buildAnimatedIcon(IconData icon, Color color) {
    return Icon(icon, color: color, size: 28);
  }

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
    final size = MediaQuery.of(context).size;
    final double maxAvatarRadius = size.width * 0.15;
    final double titleFontSize = size.width * 0.060;
    final double nameFontSize = size.width * 0.048;
    final double subTextFontSize = size.width * 0.04;

    final menuItems = [
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
        icon: Icons.restaurant_menu,
        iconColor: const Color(0xFF26A69A),
        title: 'Meal Preferences',
        titleColor: Colors.teal[700]!,
        isPro: false,
        onTap: () => _navigateToScreen(context, 'Preferences'),
      ),
      MenuItemTile(
        icon: Icons.settings,
        iconColor: const Color(0xFFEF9A9A),
        title: 'Settings',
        titleColor: Colors.pinkAccent,
        onTap: () => _navigateToScreen(context, 'Settings'),
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFFFCF7),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: -30,
              left: -30,
              child: _buildColoredCircle(const Color(0xFF26A69A), 120),
            ),
            Positioned(
              top: 100,
              right: -40,
              child: _buildColoredCircle(const Color(0xFFEF9A9A), 80),
            ),
            Positioned(
              bottom: 120,
              left: -60,
              child: _buildColoredCircle(const Color(0xFF81C784), 140),
            ),
            Positioned(
              bottom: 50,
              right: -30,
              child: _buildColoredCircle(const Color(0xFFFFB74D), 100),
            ),
            Positioned(
              top: 260,
              right: 100,
              child: _buildColoredCircle(Colors.indigo[300]!, 70),
            ),
            RefreshIndicator(
              onRefresh: _onRefresh,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.arrow_back_ios),
                          ),
                          Text(
                            'Profile',
                            style: TextStyle(
                              fontSize: titleFontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Wrap(
                            children: [
                              InkWell(
                                onTap: () async {
                                  _showLogoutDialog();
                                },
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.logout_rounded,
                                      color: Colors.red,
                                    ),
                                    Text(
                                      'Logout',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.05),
                      FadeTransition(
                        opacity: _profileFade,
                        child: Center(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight: size.height * 0.5,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: maxAvatarRadius,
                                  backgroundImage: (widget
                                              .imagePath.isNotEmpty &&
                                          Uri.tryParse(widget.imagePath)
                                                  ?.hasAbsolutePath ==
                                              true)
                                      ? NetworkImage(widget.imagePath)
                                      : AssetImage('assets/images/profile.png')
                                          as ImageProvider,
                                ),
                                SizedBox(height: size.height * 0.015),
                                Text(
                                  userName,
                                  style: TextStyle(
                                    fontSize: nameFontSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: size.height * 0.023),
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () => _navigateToScreen(
                                        context, 'My Profile'),
                                    child: Text(
                                      'My Profile',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: subTextFontSize,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.04),
                      ...List.generate(
                        menuItems.length,
                        (index) => FadeTransition(
                          opacity: _menuItemFades[index],
                          child: Column(
                            children: [
                              menuItems[index],
                              SizedBox(height: size.height * 0.023),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.15),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
