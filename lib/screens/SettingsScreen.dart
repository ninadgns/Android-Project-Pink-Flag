import 'package:flutter/material.dart';

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
        title: const Text('Clear Cache'),
        content: const Text('Are you sure you want to clear the cache?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
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
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Implement logout logic
              Navigator.pop(context);
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
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
                        onChanged: (value) => setState(() => accountPrivacy = value),
                        activeColor: const Color(0xFFFF8A80),
                      ),
                      iconColor: Colors.indigoAccent
                    ),

                    _buildSettingItem(
                      icon: Icons.notifications,
                      title: 'Notifications',
                      subtitle: 'Control app notifications and alerts.',
                      trailing: Switch(
                        value: notifications,
                        onChanged: (value) => setState(() => notifications = value),
                        activeColor: const Color(0xFFFF9999),
                      ),
                      iconColor: Colors.orange
                    ),

                    _buildSettingItem(
                      icon: Icons.cleaning_services,
                      title: 'Clear Cache',
                      subtitle: 'Free up storage by clearing cached data.',
                      onTap: _showClearCacheDialog,
                      iconColor: Colors.black26
                    ),

                    _buildSettingItem(
                      icon: Icons.star,
                      title: 'Rate App',
                      subtitle: 'Rate us on the app store and share feedback.',
                      onTap: () {
                        // rate app logic
                      },
                      iconColor: Colors.amber
                    ),

                    _buildSettingItem(
                      icon: Icons.feedback,
                      title: 'Feedback',
                      subtitle: 'Share your thoughts to help improve the app.',
                      onTap: () {
                        // feedback screen
                      },
                      iconColor: Colors.teal
                    ),

                    _buildSettingItem(
                        icon: Icons.help,
                        title: 'Help Center',
                        subtitle: 'Get assistance with frequently asked questions.',
                        onTap: () {
                          // help center
                        },
                        iconColor: Colors.deepOrangeAccent
                    ),

                    _buildSettingItem(
                      icon: Icons.info,
                      title: 'About Us',
                      subtitle: 'Learn more about our mission.',
                      onTap: () {
                        // about screen
                      },
                      iconColor: Colors.blue
                    ),

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