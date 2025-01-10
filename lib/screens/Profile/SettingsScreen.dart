// ignore_for_file: prefer_const_constructors

import 'package:dim/screens/GetStarted.dart';
import 'package:dim/services/user_provider.dart';
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
  bool accountPrivacy = false;
  bool notifications = true;

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    Color iconColor = Colors.black54,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: subtitle != null ? Text(subtitle) : null,
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFFFFE6E8),
        title: const Text('Clear Cache'),
        content: const Text('Are you sure you want to clear the cache?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
            style: TextButton.styleFrom(
              foregroundColor: Color(0xFFFF8A80),
            ),
          ),
          TextButton(
            onPressed: () {
              // Implement cache clearing logic
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cache cleared successfully')),
              );
            },
            child: const Text('Clear'),
            style: TextButton.styleFrom(
              foregroundColor: Color(0xFFFF8A80),
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
          title: const Text('Rate Our App'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('How would you rate your experience?'),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < selectedRating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 32,
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
              child: const Text('Cancel'),
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
              child: const Text('Submit'),
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
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Dismiss the dialog
            child: const Text('Cancel'),
            style: TextButton.styleFrom(
              foregroundColor: Color(0xFFFF8A80),
            ),
          ),
          TextButton(
            onPressed: () async {
              try {
                // Check if the user is signed in
                User? user = FirebaseAuth.instance.currentUser;
                print(user);
                if (user != null) {
                  // Get the list of sign-in methods for the user
                  List<String> providers = user.providerData
                      .map((userInfo) => userInfo.providerId)
                      .toList();

                  if (providers.contains('google.com')) {
                    // If signed in with Google, also sign out from Google
                    GoogleSignIn googleSignIn = GoogleSignIn();
                    await googleSignIn.signOut();
                  }

                  // Sign out from Firebase
                  await FirebaseAuth.instance.signOut();
                }

                // Navigate to GetStarted screen and clear the navigation stack
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Getstarted()),
                  (route) => false, // Remove all routes
                );
              } catch (e) {
                Navigator.pop(context); // Close the dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Logout failed: ${e.toString()}')),
                );
              }
            },
            child: const Text('Logout'),
            style: TextButton.styleFrom(
              foregroundColor: Color(0xFFFF8A80),
            ),
          ),
        ],
      ),
    );
  }

  void _showFeedbackDialog() {
    final TextEditingController feedbackController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFFFFE6E8),
        title: const Text('Send Feedback'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Share your thoughts with us:'),
            const SizedBox(height: 16),
            TextField(
              controller: feedbackController,
              maxLines: 5,
              cursorColor: Color(0xFFFF8A80),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: Color(0xFFFF8A80), width: 1),
                ),
                hintText: 'Enter your feedback here...',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
            style: TextButton.styleFrom(
              foregroundColor: Color(0xFFFF8A80),
            ),
          ),
          TextButton(
            onPressed: () async {
              if (feedbackController.text.isNotEmpty) {
                Navigator.pop(context);
              }
            },
            child: const Text('Submit'),
            style: TextButton.styleFrom(
              foregroundColor: Color(0xFFFF8A80),
            ),
          ),
        ],
      ),
    );
  }

  void _showHelpCenterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFFFFE6E8),
        title: const Text('Help Center'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text('Frequently Asked Questions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              Text('1. How do I update my profile?',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Go to Profile > Edit Profile to update your information.'),
              SizedBox(height: 12),
              Text('2. How can I change my password?',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Go to Settings > Account Privacy > Change Password.'),
              SizedBox(height: 12),
              Text('3. How do I report a problem?',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Use the Feedback option in Settings to report any issues.'),
              SizedBox(height: 16),
              Text('Contact Support',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('Email: support@app.com\nPhone: 1-800-APP'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
            style: TextButton.styleFrom(
              foregroundColor: Color(0xFFFF8A80),
            ),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFFFFE6E8),
        title: const Text('About Us'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text('Our Mission',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(
                  'We strive to create innovative solutions that make people\'s lives easier and more connected.'),
              SizedBox(height: 16),
              Text('Our Goals',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('• Provide exceptional user experience\n'
                  '• Maintain highest security standards\n'
                  '• Continuous innovation and improvement\n'
                  '• Build a strong, supportive community'),
              SizedBox(height: 16),
              Text('App Version: 1.0.0\n'
                  'Developer: A\n'
                  'Website: www.a.com'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
            style: TextButton.styleFrom(
              foregroundColor: Color(0xFFFF8A80),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Settings List
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  children: [
                    _buildSettingItem(
                        icon: Icons.security,
                        title: 'Account Privacy',
                        subtitle: 'Manage who can see your profile and posts.',
                        trailing: Switch(
                          value: accountPrivacy,
                          onChanged: (value) =>
                              setState(() => accountPrivacy = value),
                          activeColor: const Color(0xFFFF8A80),
                        ),
                        iconColor: Colors.indigoAccent),
                    _buildSettingItem(
                        icon: Icons.notifications,
                        title: 'Notifications',
                        subtitle: 'Control app notifications and alerts.',
                        trailing: Switch(
                          value: notifications,
                          onChanged: (value) =>
                              setState(() => notifications = value),
                          activeColor: const Color(0xFFFF9999),
                        ),
                        iconColor: Colors.orange),
                    _buildSettingItem(
                        icon: Icons.cleaning_services,
                        title: 'Clear Cache',
                        subtitle: 'Free up storage by clearing cached data.',
                        onTap: _showClearCacheDialog,
                        iconColor: Colors.black26),
                    _buildSettingItem(
                        icon: Icons.star,
                        title: 'Rate App',
                        subtitle:
                            'Rate us on the app store and share feedback.',
                        onTap: _showRatingDialog,
                        iconColor: Colors.amber),
                    _buildSettingItem(
                        icon: Icons.feedback,
                        title: 'Feedback',
                        subtitle:
                            'Share your thoughts to help improve the app.',
                        onTap: _showFeedbackDialog,
                        iconColor: Colors.teal),
                    _buildSettingItem(
                        icon: Icons.help,
                        title: 'Help Center',
                        subtitle:
                            'Get assistance with frequently asked questions.',
                        onTap: _showHelpCenterDialog,
                        iconColor: Colors.deepOrangeAccent),
                    _buildSettingItem(
                        icon: Icons.info,
                        title: 'About Us',
                        subtitle: 'Learn more about our mission.',
                        onTap: _showAboutDialog,
                        iconColor: Colors.blue),
                    _buildSettingItem(
                      icon: Icons.logout,
                      title: 'Logout',
                      subtitle: 'Sign out of your account securely.',
                      iconColor: Colors.red,
                      onTap: _showLogoutDialog,
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
