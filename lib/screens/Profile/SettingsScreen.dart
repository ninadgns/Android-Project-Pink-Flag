
import 'package:dim/models/FirebaseApi.dart';
import 'package:dim/models/NotificationManagement/NotificationSettings.dart';
import 'package:dim/screens/GetStarted.dart';
import 'package:dim/screens/Profile/AboutScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  //bool accountPrivacy = false;
  bool notifications = true;
  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    Color iconColor = Colors.black54,
  }) {
    // Get screen size for responsive design
    final size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: size.width * 0.05,
        vertical: size.height * 0.01,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(size.width * 0.04),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: size.width * 0.04,
          vertical: size.height * 0.01,
        ),
        leading: Icon(
          icon,
          color: iconColor,
          size: size.width * 0.06, // Responsive icon size
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: size.width * 0.04, // Responsive font size
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: TextStyle(
                  fontSize: size.width * 0.035, // Responsive subtitle size
                ),
              )
            : null,
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }

  // Modified dialog text styles for dynamic font sizes
  TextStyle _getDialogTitleStyle(BuildContext context) {
    return TextStyle(
      fontSize: MediaQuery.of(context).size.width * 0.04,
      fontWeight: FontWeight.bold,
    );
  }

  TextStyle _getDialogContentStyle(BuildContext context) {
    return TextStyle(
      fontSize: MediaQuery.of(context).size.width * 0.03,
    );
  }

  TextStyle _getDialogButtonStyle(BuildContext context) {
    return TextStyle(
      fontSize: MediaQuery.of(context).size.width * 0.035,
    );
  }

  TextStyle _getDialogSubheaderStyle(BuildContext context) {
    return TextStyle(
      fontSize: MediaQuery.of(context).size.width * 0.035,
      fontWeight: FontWeight.bold,
    );
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFFFFE6E8),
        title: Text(
          'Clear Cache',
          style: _getDialogTitleStyle(context),
        ),
        content: Text(
          'Are you sure you want to clear the cache?',
          style: _getDialogContentStyle(context),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: Color(0xFFFF8A80),
            ),
            child: Text(
              'Cancel',
              style: _getDialogButtonStyle(context),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Cache cleared successfully',
                    style: _getDialogContentStyle(context),
                  ),
                ),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: Color(0xFFFF8A80),
            ),
            child: Text(
              'Clear',
              style: _getDialogButtonStyle(context),
            ),
          ),
        ],
      ),
    );
  }

  void _showRatingDialog() {
    int selectedRating = 0;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: Color(0xFFFFE6E8),
          title: Text('Rate Our App', style: _getDialogTitleStyle(context)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'How would you rate your experience?',
                style: _getDialogContentStyle(context),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < selectedRating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: MediaQuery.of(context).size.width * 0.08,
                    ),
                    onPressed: () {
                      setState(() {
                        selectedRating = index + 1;
                      });
                    },
                  );
                }),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: Color(0xFFFF8A80),
              ),
              child: Text('Cancel', style: _getDialogButtonStyle(context)),
            ),
            TextButton(
              onPressed: () async {
                if (selectedRating > 0) {
                  Navigator.pop(context);
                }
              },
              style: TextButton.styleFrom(
                foregroundColor: Color(0xFFFF8A80),
              ),
              child: Text('Submit', style: _getDialogButtonStyle(context)),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFFFFE6E8),
        title: Text('Logout', style: _getDialogTitleStyle(context)),
        content: Text(
          'Are you sure you want to logout?',
          style: _getDialogContentStyle(context),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: Color(0xFFFF8A80),
            ),
            child: Text('Cancel', style: _getDialogButtonStyle(context)),
          ),
          TextButton(
            onPressed: () async {
              try {
                User? user = FirebaseAuth.instance.currentUser;
                print(user);
                if (user != null) {
                  List<String> providers = user.providerData
                      .map((userInfo) => userInfo.providerId)
                      .toList();

                  if (providers.contains('google.com')) {
                    GoogleSignIn googleSignIn = GoogleSignIn();
                    await googleSignIn.signOut();
                  }

                  await FirebaseAuth.instance.signOut();
                }

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Getstarted()),
                  (route) => false,
                );
              } catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Logout failed: ${e.toString()}',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.035,
                      ),
                    ),
                  ),
                );
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: Color(0xFFFF8A80),
            ),
            child: Text('Logout', style: _getDialogButtonStyle(context)),
          ),
        ],
      ),
    );
  }

  void _showFeedbackDialog() {
    final TextEditingController feedbackController = TextEditingController();
    final size = MediaQuery.of(context).size;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFFFFE6E8),
        title: Text('Send Feedback', style: _getDialogTitleStyle(context)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Share your thoughts with us:',
              style: _getDialogContentStyle(context),
            ),
            SizedBox(height: size.height * 0.02),
            TextField(
              controller: feedbackController,
              maxLines: 5,
              cursorColor: Color(0xFFFF8A80),
              style: TextStyle(fontSize: size.width * 0.04),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(size.width * 0.03),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(size.width * 0.03),
                  borderSide:
                      const BorderSide(color: Color(0xFFFF8A80), width: 1),
                ),
                hintText: 'Enter your feedback here...',
                hintStyle: TextStyle(fontSize: size.width * 0.04),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: Color(0xFFFF8A80),
            ),
            child: Text('Cancel', style: _getDialogButtonStyle(context)),
          ),
          TextButton(
            onPressed: () async {
              if (feedbackController.text.isNotEmpty) {
                Navigator.pop(context);
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: Color(0xFFFF8A80),
            ),
            child: Text('Submit', style: _getDialogButtonStyle(context)),
          ),
        ],
      ),
    );
  }

  void _showHelpCenterDialog() {
    final size = MediaQuery.of(context).size;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFFFFE6E8),
        title: Text('Help Center', style: _getDialogTitleStyle(context)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Frequently Asked Questions',
                  style: _getDialogSubheaderStyle(context)),
              SizedBox(height: size.height * 0.02),
              Text('1. How do I update my profile?',
                  style: TextStyle(
                    fontSize: size.width * 0.04,
                    fontWeight: FontWeight.bold,
                  )),
              Text('Go to Profile > Edit Profile to update your information.',
                  style: _getDialogContentStyle(context)),
              SizedBox(height: size.height * 0.015),
              Text('2. How can I change my password?',
                  style: TextStyle(
                    fontSize: size.width * 0.04,
                    fontWeight: FontWeight.bold,
                  )),
              Text('Go to Settings > Account Privacy > Change Password.',
                  style: _getDialogContentStyle(context)),
              SizedBox(height: size.height * 0.015),
              Text('3. How do I report a problem?',
                  style: TextStyle(
                    fontSize: size.width * 0.04,
                    fontWeight: FontWeight.bold,
                  )),
              Text('Use the Feedback option in Settings to report any issues.',
                  style: _getDialogContentStyle(context)),
              SizedBox(height: size.height * 0.02),
              Text('Contact Support', style: _getDialogSubheaderStyle(context)),
              SizedBox(height: size.height * 0.01),
              Text('Email: support@app.com\nPhone: 1-800-APP',
                  style: _getDialogContentStyle(context)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: Color(0xFFFF8A80),
            ),
            child: Text('Close', style: _getDialogButtonStyle(context)),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    final size = MediaQuery.of(context).size;
    // showDialog(
    //   context: context,
    //   builder: (context) => AlertDialog(
    //     backgroundColor: Color(0xFFFFE6E8),
    //     title: Text('About Us', style: _getDialogTitleStyle(context)),
    //     content: SingleChildScrollView(
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         mainAxisSize: MainAxisSize.min,
    //         children: [
    //           Text('Our Mission', style: _getDialogSubheaderStyle(context)),
    //           SizedBox(height: size.height * 0.01),
    //           Text(
    //             'We strive to create innovative solutions that make people\'s lives easier and more connected.',
    //             style: _getDialogContentStyle(context),
    //           ),
    //           SizedBox(height: size.height * 0.02),
    //           Text('Our Goals', style: _getDialogSubheaderStyle(context)),
    //           SizedBox(height: size.height * 0.01),
    //           Text(
    //             '• Provide exceptional user experience\n'
    //                 '• Maintain highest security standards\n'
    //                 '• Continuous innovation and improvement\n'
    //                 '• Build a strong, supportive community',
    //             style: _getDialogContentStyle(context),
    //           ),
    //           SizedBox(height: size.height * 0.02),
    //           Text(
    //             'App Version: 1.0.0\n'
    //                 'Developer: A\n'
    //                 'Website: www.a.com',
    //             style: _getDialogContentStyle(context),
    //           ),
    //         ],
    //       ),
    //     ),
    //     actions: [
    //       TextButton(
    //         onPressed: () => Navigator.pop(context),
    //         style: TextButton.styleFrom(
    //           foregroundColor: Color(0xFFFF8A80),
    //         ),
    //         child: Text('Close', style: _getDialogButtonStyle(context)),
    //       ),
    //     ],
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    final isNotificationEnabled = Provider.of<NotificationSettings>(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFFFFCFD0),
              const Color(0xFFFFE5E5),
              const Color(0xFFFFF0F0),
              Colors.white.withOpacity(0.9),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App Bar
              Padding(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        size: MediaQuery.of(context).size.width * 0.06,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.05,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Settings List
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.01),
                  children: [
                    _buildSettingItem(
                        icon: Icons.notifications,
                        title: 'Notifications',
                        subtitle: 'Control app notifications and alerts.',
                        trailing: Switch(
                          value: isNotificationEnabled.isNotificationsEnabled,
                          onChanged: (value) async {
                            // setState(()  {
                            //
                            //   // await FirebaseApi.initNotifications(enableNotifications: value);
                            // });
                            await isNotificationEnabled
                                .toggleNotifications(value);
                            await FirebaseApi()
                                .initNotifications(enableNotifications: value);
                          },
                          activeColor: const Color(0xFFFF9999),
                        ),
                        iconColor: Colors.orange),
                    _buildSettingItem(
                      icon: Icons.cleaning_services,
                      title: 'Clear Cache',
                      subtitle: 'Free up storage by clearing cached data.',
                      onTap: _showClearCacheDialog,
                      iconColor: Colors.indigo,
                    ),
                    _buildSettingItem(
                      icon: Icons.star,
                      title: 'Rate App',
                      subtitle: 'Rate us on the app store and share feedback.',
                      onTap: _showRatingDialog,
                      iconColor: Colors.amber,
                    ),
                    _buildSettingItem(
                      icon: Icons.feedback,
                      title: 'Feedback',
                      subtitle: 'Share your thoughts to help improve the app.',
                      onTap: _showFeedbackDialog,
                      iconColor: Colors.teal,
                    ),
                    _buildSettingItem(
                      icon: Icons.help,
                      title: 'Help Center',
                      subtitle:
                          'Get assistance with frequently asked questions.',
                      onTap: _showHelpCenterDialog,
                      iconColor: Colors.deepOrangeAccent,
                    ),
                    _buildSettingItem(
                      icon: Icons.info,
                      title: 'About Us',
                      subtitle: 'Learn more about our mission.',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AboutScreen()),
                        );
                      },
                      iconColor: Colors.blue,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
