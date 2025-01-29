import 'dart:io' show File;

import 'package:dim/models/ProfileInfoModel.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../services/ProfileService.dart';

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

  Future<void> _saveChanges() async {
    try {
      if (profileinfo == null) return;
      await _profileService.updateProfile(profileinfo!);
      setState(() => isEditMode = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Changes saved successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving changes: $e')),
      );
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        profileinfo?.profileImageBytes = bytes;
        profileinfo?.profileImagePath = pickedFile.path;
      });
    }
  }

  void _editSocialMediaHandle(SocialMediaHandle media) {
    final controller = TextEditingController(text: media.handle);
    final screenSize = MediaQuery.of(context).size;

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: const Color(0xFFB2EBF2),
          title: Text(
            'Edit ${media.platform} Handle',
            style: TextStyle(fontSize: screenSize.width * 0.045),
          ),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: 'Handle',
              labelStyle: TextStyle(fontSize: screenSize.width * 0.04),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF00ACC1),
              ),
              child: Text('Cancel',
                  style: TextStyle(fontSize: screenSize.width * 0.035)),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  String newHandle = controller.text;
                  var socialMediaIds =
                      profileinfo!.socialMediaHandles.map((item) {
                    if (item.platform == media.platform) {
                      return SocialMediaHandle(
                          platform: item.platform, handle: newHandle);
                    }
                    return item;
                  }).toList();
                });
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF00ACC1),
              ),
              child: Text('Done',
                  style: TextStyle(fontSize: screenSize.width * 0.035)),
            ),
          ],
        );
      },
    );
  }

  void _addSocialMediaHandle() {
    final platformController = TextEditingController();
    final handleController = TextEditingController();
    final screenSize = MediaQuery.of(context).size;

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: const Color(0xFFB2EBF2),
          title: Text(
            'Add Social Media',
            style: TextStyle(fontSize: screenSize.width * 0.045),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                cursorColor: Colors.black,
                controller: platformController,
                decoration: InputDecoration(
                  labelText: 'Platform (e.g. Instagram)',
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: screenSize.width * 0.04,
                  ),
                  border: const OutlineInputBorder(),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1),
                  ),
                ),
              ),
              SizedBox(height: screenSize.height * 0.01),
              TextField(
                cursorColor: Colors.black,
                controller: handleController,
                decoration: InputDecoration(
                  labelText: 'Handle (e.g. @username)',
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: screenSize.width * 0.04,
                  ),
                  border: const OutlineInputBorder(),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF00ACC1),
              ),
              child: Text('Cancel',
                  style: TextStyle(fontSize: screenSize.width * 0.035)),
            ),
            TextButton(
              onPressed: () {
                if (platformController.text.isNotEmpty &&
                    handleController.text.isNotEmpty) {
                  setState(() {
                    profileinfo!.socialMediaHandles.add(
                      SocialMediaHandle(
                        platform: platformController.text,
                        handle: handleController.text,
                      ),
                    );
                  });
                  Navigator.pop(context);
                }
              },
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF00ACC1),
              ),
              child: Text('Add',
                  style: TextStyle(fontSize: screenSize.width * 0.035)),
            ),
          ],
        );
      },
    );
  }

  void _editField(String fieldName, String initialValue, bool multiline,
      Function(String) onSave) {
    final controller = TextEditingController(text: initialValue);
    final screenSize = MediaQuery.of(context).size;

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: const Color(0xFFB2EBF2),
          title: Text(
            'Edit $fieldName',
            style: TextStyle(fontSize: screenSize.width * 0.045),
          ),
          content: TextField(
            cursorColor: Colors.black,
            controller: controller,
            keyboardType:
                multiline ? TextInputType.multiline : TextInputType.text,
            maxLines: multiline ? 4 : 1,
            decoration: InputDecoration(
              hintText: 'Enter new $fieldName',
              hintStyle: TextStyle(
                color: Colors.black,
                fontSize: screenSize.width * 0.04,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.black, width: 1),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF00ACC1),
              ),
              child: Text('Cancel',
                  style: TextStyle(fontSize: screenSize.width * 0.035)),
            ),
            TextButton(
              onPressed: () {
                onSave(controller.text);
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF00ACC1),
              ),
              child: Text('Save',
                  style: TextStyle(fontSize: screenSize.width * 0.035)),
            ),
          ],
        );
      },
    );
  }

  void _shareProfile() {
    final profileLink =
        'https://example.com/users/${profileinfo?.fullName.replaceAll(' ', '_')}';
    Share.share('Check out my profile: $profileLink');
  }

  Widget _buildEditableField({
    required String label,
    required String value,
    required void Function() onEdit,
    bool isMultiline = false,
    IconData icon = Icons.edit,
  }) {
    final screenSize = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.only(bottom: screenSize.height * 0.02),
      padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
      decoration: BoxDecoration(
        color: const Color(0xFFE0F7FA).withOpacity(0.8),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        crossAxisAlignment:
            isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding:
                  EdgeInsets.symmetric(vertical: screenSize.height * 0.015),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.bold,
                      fontSize: screenSize.width * 0.04,
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.005),
                  Text(
                    value,
                    style: TextStyle(fontSize: screenSize.width * 0.04),
                  ),
                ],
              ),
            ),
          ),
          if (isEditMode)
            IconButton(
              icon: Icon(icon, color: Colors.grey[600]),
              iconSize: screenSize.width * 0.05,
              onPressed: onEdit,
            ),
        ],
      ),
    );
  }

  Widget _buildSocialMediaSection() {
    final screenSize = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.only(bottom: screenSize.height * 0.02),
      padding: EdgeInsets.symmetric(
        horizontal: screenSize.width * 0.05,
        vertical: screenSize.height * 0.015,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFE0F7FA).withOpacity(0.8),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Social Media',
            style: TextStyle(
              color: Colors.grey[700],
              fontWeight: FontWeight.bold,
              fontSize: screenSize.width * 0.04,
            ),
          ),
          SizedBox(height: screenSize.height * 0.01),
          ...profileinfo!.socialMediaHandles.map((item) {
            return Padding(
              padding:
                  EdgeInsets.symmetric(vertical: screenSize.height * 0.005),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${item.platform}: ${item.handle}',
                    style: TextStyle(fontSize: screenSize.width * 0.04),
                  ),
                  if (isEditMode)
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.grey[600]),
                      onPressed: () => _editSocialMediaHandle(item),
                      iconSize: screenSize.width * 0.05,
                      constraints: const BoxConstraints(),
                    ),
                ],
              ),
            );
          }),
          if (isEditMode)
            TextButton.icon(
              icon: Icon(Icons.add, size: screenSize.width * 0.05),
              label: Text(
                'Add social media',
                style: TextStyle(fontSize: screenSize.width * 0.04),
              ),
              onPressed: _addSocialMediaHandle,
            )
        ],
      ),
    );
  }

  Widget _buildStat(int number, String label) {
    final screenSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenSize.width * 0.04,
        vertical: screenSize.height * 0.015,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFE0F7FA).withOpacity(0.8),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            number.toString(),
            style: TextStyle(
              fontSize: screenSize.width * 0.05,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF00796B),
            ),
          ),
          SizedBox(height: screenSize.height * 0.005),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: screenSize.width * 0.035,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final bodyPadding = screenSize.width * 0.03;
    final avatarRadius = screenSize.width * 0.12;

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

    ImageProvider backgroundImage;
    if (profileinfo?.profileImageBytes != null) {
      backgroundImage = MemoryImage(profileinfo!.profileImageBytes!);
    } else if (profileinfo!.profileImagePath.startsWith('assets/')) {
      backgroundImage = AssetImage(profileinfo!.profileImagePath);
    } else {
      if (kIsWeb) {
        backgroundImage = NetworkImage(widget.imagePath);
      } else {
        backgroundImage = FileImage(File(profileinfo!.profileImagePath));
      }
    }

    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: screenSize.height * 0.25,
            width: double.infinity,
            child: CustomPaint(
              painter: SoftPastelBackgroundPainter(),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: screenSize.width * 0.04),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(isEditMode ? Icons.close : Icons.edit),
                            onPressed: () {
                              setState(() {
                                isEditMode = !isEditMode;
                              });
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.share),
                            onPressed: _shareProfile,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(bodyPadding),
                    child: Column(
                      children: [
                        SizedBox(height: screenSize.height * 0.01),
                        Text(
                          'My Profile',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: screenSize.width * 0.06,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: screenSize.height * 0.03),
                        Center(
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              CircleAvatar(
                                  radius: avatarRadius,
                                  backgroundImage: (widget
                                              .imagePath.isNotEmpty &&
                                          Uri.tryParse(widget.imagePath)
                                                  ?.hasAbsolutePath ==
                                              true)
                                      ? NetworkImage(widget.imagePath)
                                      : AssetImage('assets/images/profile.png')
                                          as ImageProvider),
                              if (isEditMode)
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: InkWell(
                                    onTap: _pickImage,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black54,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: screenSize.width * 0.005,
                                        ),
                                      ),
                                      padding: EdgeInsets.all(
                                          screenSize.width * 0.015),
                                      child: Icon(
                                        Icons.camera_alt,
                                        color: Colors.white,
                                        size: screenSize.width * 0.05,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                            vertical: screenSize.height * 0.02,
                            horizontal: screenSize.width * 0.03,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                  child: _buildStat(
                                      profileinfo!.recipesCount, 'Recipes')),
                              SizedBox(width: screenSize.width * 0.02),
                              Expanded(
                                  child: _buildStat(profileinfo!.followingCount,
                                      'Following')),
                              SizedBox(width: screenSize.width * 0.02),
                              Expanded(
                                  child: _buildStat(
                                      profileinfo!.followerCount, 'Followers')),
                            ],
                          ),
                        ),
                        SizedBox(height: screenSize.height * 0.03),
                        _buildEditableField(
                          label: 'Full Name',
                          value: profileinfo!.fullName,
                          onEdit: () => _editField(
                              'Full Name', profileinfo!.fullName, false,
                              (newVal) {
                            final nameRegExp =
                                RegExp(r"^[a-zA-Zà-úÀ-Ú\s'-]{2,40}$");
                            if (nameRegExp.hasMatch(newVal)) {
                              setState(() => profileinfo!.fullName = newVal);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Invalid name. Use only letters, spaces, hyphens, or apostrophes.')));
                            }
                          }),
                        ),
                        _buildEditableField(
                          label: 'User Name',
                          value: profileinfo!.userName,
                          onEdit: () => _editField(
                              'User Name', profileinfo!.userName, false,
                              (newVal) {
                            setState(() => profileinfo!.userName = newVal);
                          }),
                        ),
                        _buildEditableField(
                          label: 'Email',
                          value: profileinfo!.email,
                          onEdit: () => _editField(
                              'Email', profileinfo!.email, false, (newVal) {
                            final emailRegExp = RegExp(
                                r'^[\w-.]+@[\w-]+\.(com|org|net|edu|gov)$');
                            if (emailRegExp.hasMatch(newVal)) {
                              setState(() => profileinfo!.email = newVal);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Invalid email address. Use a valid format (e.g., user@example.com).')));
                            }
                          }),
                        ),
                        _buildEditableField(
                          label: 'Phone Number',
                          value: profileinfo!.phoneNumber,
                          onEdit: () => _editField(
                              'Phone Number', profileinfo!.phoneNumber, false,
                              (newVal) {
                            final phoneRegExp = RegExp(r'^\+?\d{10,15}$');
                            if (phoneRegExp.hasMatch(newVal)) {
                              setState(() => profileinfo!.phoneNumber = newVal);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Invalid phone number. Use digits with optional +.')));
                            }
                          }),
                        ),
                        _buildEditableField(
                          label: 'Date of Birth',
                          value: profileinfo!.dateofBirth != null
                              ? DateFormat('yyyy-MM-dd')
                                  .format(profileinfo!.dateofBirth!)
                              : '',
                          onEdit: () => _editField(
                              'Date of Birth',
                              profileinfo!.dateofBirth != null
                                  ? DateFormat('yyyy-MM-dd')
                                      .format(profileinfo!.dateofBirth!)
                                  : '',
                              false, (newVal) {
                            setState(() => profileinfo!.dateofBirth =
                                DateTime.parse(newVal));
                          }),
                        ),
                        _buildEditableField(
                          label: 'Bio',
                          value: profileinfo!.bio,
                          isMultiline: true,
                          onEdit: () => _editField(
                              'Bio', profileinfo!.bio, true, (newVal) {
                            setState(() => profileinfo!.bio = newVal);
                          }),
                        ),
                        _buildEditableField(
                          label: 'Workplace',
                          value: profileinfo!.workplace,
                          onEdit: () => _editField(
                              'Workplace', profileinfo!.workplace, false,
                              (newVal) {
                            setState(() => profileinfo!.workplace = newVal);
                          }),
                        ),
                        _buildEditableField(
                          label: 'Living City',
                          value: profileinfo!.city,
                          onEdit: () => _editField(
                              'Living City', profileinfo!.city, false,
                              (newVal) {
                            setState(() => profileinfo!.city = newVal);
                          }),
                        ),
                        _buildSocialMediaSection(),
                        if (isEditMode)
                          Padding(
                            padding: EdgeInsets.all(screenSize.width * 0.04),
                            child: ElevatedButton(
                              onPressed: () {
                                _profileService.updateProfile(profileinfo!);
                                setState(() {
                                  isEditMode = false;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('Changes saved successfully')),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0E98A7),
                                minimumSize: Size(
                                    double.infinity, screenSize.height * 0.06),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                'Save Changes',
                                style: TextStyle(
                                  fontSize: screenSize.width * 0.04,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
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

class SoftPastelBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final pastelBlue = const Color(0xFFADD6CF).withOpacity(0.3);
    final pastelPink = const Color(0xFFF0AF9E).withOpacity(0.3);

    final paintBlue = Paint()
      ..color = pastelBlue
      ..style = PaintingStyle.fill;
    final paintPink = Paint()
      ..color = pastelPink
      ..style = PaintingStyle.fill;

    Path path1 = Path();
    path1.moveTo(0, size.height * 0.1);
    path1.quadraticBezierTo(size.width * 0.2, size.height * 0.0,
        size.width * 0.4, size.height * 0.15);
    path1.quadraticBezierTo(size.width * 0.6, size.height * 0.3,
        size.width * 0.2, size.height * 0.35);
    path1.quadraticBezierTo(
        size.width * 0.05, size.height * 0.4, 0, size.height * 0.35);
    path1.close();
    canvas.drawPath(path1, paintBlue);

    Path path2 = Path();
    path2.moveTo(size.width, size.height * 0.9);
    path2.quadraticBezierTo(size.width * 0.8, size.height * 1.0,
        size.width * 0.6, size.height * 0.85);
    path2.quadraticBezierTo(size.width * 0.4, size.height * 0.7,
        size.width * 0.8, size.height * 0.65);
    path2.quadraticBezierTo(
        size.width * 0.95, size.height * 0.6, size.width, size.height * 0.65);
    path2.close();
    canvas.drawPath(path2, paintPink);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
