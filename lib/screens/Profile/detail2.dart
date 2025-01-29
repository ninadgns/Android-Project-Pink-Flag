import 'dart:io' show File;

import 'package:dim/models/ProfileInfoModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../services/ProfileService.dart';
import '../Onboarding.dart';

class ProfileDetailInfoScreen extends StatefulWidget {
  final String imagePath;

  const ProfileDetailInfoScreen({super.key, required this.imagePath});

  @override
  State<ProfileDetailInfoScreen> createState() =>
      _ProfileDetailInfoScreenState();
}

class _ProfileDetailInfoScreenState extends State<ProfileDetailInfoScreen>
    with SingleTickerProviderStateMixin {
  bool isEditMode = false;
  bool isLoading = true;
  ProfileInfoModel? profileinfo;
  late final ProfileService _profileService;

  @override
  void initState() {
    super.initState();
    _profileService = ProfileService(supabase: Supabase.instance.client);
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      setState(() => isLoading = true);
      final profile = await _profileService.getCurrentUserProfile();
      setState(() {
        profileinfo = profile;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading profile: $e')),
      );
    }
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

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (profileinfo == null) {
      return const Scaffold(
        body: Center(
          child: Text('Error loading profile'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFFCF7),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
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
                      fontSize: screenSize.width * 0.060,
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
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(screenSize.width * 0.03),
                child: Column(
                  children: [
                    SizedBox(height: screenSize.height * 0.03),
                    CircleAvatar(
                      radius: screenSize.width * 0.12,
                      backgroundImage: (widget.imagePath.isNotEmpty &&
                              Uri.tryParse(widget.imagePath)?.hasAbsolutePath ==
                                  true)
                          ? NetworkImage(widget.imagePath)
                          : AssetImage('assets/images/profile.png')
                              as ImageProvider,
                    ),
                    SizedBox(height: screenSize.height * 0.02),
                    Text(
                      profileinfo!.fullName,
                      style: TextStyle(
                        fontSize: screenSize.width * 0.05,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Additional profile fields...
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
