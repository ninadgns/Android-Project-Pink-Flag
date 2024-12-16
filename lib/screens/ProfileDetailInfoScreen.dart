import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:typed_data';

class ProfileDetailInfoScreen extends StatefulWidget {
  const ProfileDetailInfoScreen({super.key});

  @override
  State<ProfileDetailInfoScreen> createState() => _ProfileDetailInfoScreenState();
}

class _ProfileDetailInfoScreenState extends State<ProfileDetailInfoScreen>
    with SingleTickerProviderStateMixin {
  String profileImagePath = 'assets/images/profile.png';
  Uint8List? profileImageBytes;

  String userName = 'Sofia';
  String fullName = 'Sofia Anderson';
  String email = 'sofia@example.com';
  String phoneNumber = '+1 234 567 8900';
  String bio = 'Food lover, cook, and traveler.';
  String city = 'New York';
  String workplace = 'Culinary Institute of America';
  String follower='98';
  String following='142';
  String recipes= '23';

  List<Map<String, String>> socialMediaIds = [
    {'platform': 'Instagram', 'handle': '@sofiacooks'},
  ];

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        profileImageBytes = bytes;
        profileImagePath = pickedFile.path;
      });
    }
  }

  void _editSocialMediaHandle(Map<String, String> platform) {
    final controller = TextEditingController(text: platform['handle']);
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: Color(0xFFB2EBF2),
          title: Text('Edit ${platform['platform']} Handle'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Handle',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
              style: TextButton.styleFrom(
                foregroundColor: Color(0xFF00ACC1), // Save button text color
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  socialMediaIds = socialMediaIds.map((item) {
                    if (item == platform) {
                      return {'platform': platform['platform']!, 'handle': controller.text};
                    }
                    return item;
                  }).toList();
                });
                Navigator.pop(context);
              },
              child: const Text('Save'),
              style: TextButton.styleFrom(
                foregroundColor: Color(0xFF00ACC1), // Save button text color
              ),
            ),
          ],
        );
      },
    );
  }

  void _addSocialMediaHandle() {
    final platformController = TextEditingController();
    final handleController = TextEditingController();
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: Color(0xFFB2EBF2),
          title: const Text('Add Social Media'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: platformController,
                decoration: const InputDecoration(
                  labelText: 'Platform (e.g. Instagram)',
                ),
              ),
              TextField(
                controller: handleController,
                decoration: const InputDecoration(
                  labelText: 'Handle (e.g. @username)',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
              style: TextButton.styleFrom(
                foregroundColor: Color(0xFF00ACC1), // Save button text color
              ),
            ),
            TextButton(
              onPressed: () {
                if (platformController.text.isNotEmpty &&
                    handleController.text.isNotEmpty) {
                  setState(() {
                    socialMediaIds = List.from(socialMediaIds)
                      ..add({
                        'platform': platformController.text,
                        'handle': handleController.text,
                      });
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
              style: TextButton.styleFrom(
                foregroundColor: Color(0xFF00ACC1), // Save button text color
              ),
            ),
          ],
        );
      },
    );
  }

  void _editField(String fieldName, String initialValue, bool multiline, Function(String) onSave) {
    final controller = TextEditingController(text: initialValue);
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: Color(0xFFB2EBF2),
          title: Text('Edit $fieldName'),
          content: TextField(
            controller: controller,
            keyboardType: multiline ? TextInputType.multiline : TextInputType.text,
            maxLines: multiline ? 4 : 1,
            decoration: InputDecoration(
              hintText: 'Enter new $fieldName',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
              style: TextButton.styleFrom(
                foregroundColor: Color(0xFF00ACC1), // Save button text color
              ),
            ),
            TextButton(
              onPressed: () {
                onSave(controller.text);
                Navigator.pop(context);
              },
              child: const Text('Save'),
              style: TextButton.styleFrom(
                foregroundColor: Color(0xFF00ACC1), // Save button text color
              ),
            ),
          ],
        );
      },
    );
  }

  void _shareProfile() {
    // A unique link could be generated from user's name
    final profileLink = 'https://example.com/users/${fullName.replaceAll(' ', '_')}';
    Share.share('Check out my profile: $profileLink');
  }

  Widget _buildEditableField({
    required String label,
    required String value,
    required void Function() onEdit,
    bool isMultiline = false,
    IconData icon = Icons.edit,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
        color: const Color(0xFFE0F7FA).withOpacity(0.8),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        crossAxisAlignment: isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: TextStyle(
                          color: Colors.grey[700], fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: Icon(icon, color: Colors.grey[600]),
            iconSize: 20.0,
            onPressed: onEdit,
          ),
        ],
      ),
    );
  }

  Widget _buildSocialMediaSection() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: const Color(0xFFE0F7FA).withOpacity(0.8),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Social Media',
              style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...socialMediaIds.map((platform) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      '${platform['platform']}: ${platform['handle']}',
                      style: const TextStyle(fontSize: 16)
                  ),
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.grey[600], size: 20),
                    onPressed: () => _editSocialMediaHandle(platform),
                    iconSize: 20.0,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            );
          }).toList(),
          const SizedBox(height: 8),
          TextButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Add social media'),
            onPressed: _addSocialMediaHandle,
          )
        ],
      ),
    );
  }

  Widget _buildStat(String number, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
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
            number,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00796B),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider backgroundImage;
    if (profileImageBytes != null) {
      backgroundImage = MemoryImage(profileImageBytes!);
    } else if (profileImagePath.startsWith('assets/')) {
      backgroundImage = AssetImage(profileImagePath);
    } else {
      if (kIsWeb) {
        backgroundImage = const AssetImage('assets/images/profile.png');
      } else {
        backgroundImage = FileImage(File(profileImagePath));
      }
    }

    return Scaffold(
      // Adding a stack so we can put a custom painted background behind the main content
      body: Stack(
        children: [
          // Custom Painted Background with soothing patterns
          Container(
            height: 200, // Adjust height as needed
            width: double.infinity, // Adjust width as needed
            child: CustomPaint(
              painter: SoftPastelBackgroundPainter(),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black),
                        iconSize: 20.0,
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.share, color: Colors.black),
                        iconSize: 20.0,
                        onPressed: _shareProfile,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text('My Profile',
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 30),
                  Center(
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: backgroundImage,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: InkWell(
                            onTap: _pickImage,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              padding: const EdgeInsets.all(6),
                              child: const Icon(Icons.camera_alt,
                                  color: Colors.white, size: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: _buildStat(recipes, 'Recipes'),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildStat(following, 'Following'),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildStat(follower, 'Followers'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildEditableField(
                    label: 'Full Name',
                    value: fullName,
                    onEdit: () => _editField('Full Name', fullName, false, (newVal) {
                      setState(() => fullName = newVal);
                    }),
                  ),
                  _buildEditableField(
                    label: 'User Name',
                    value: userName,
                    onEdit: () => _editField('Full Name', fullName, false, (newVal) {
                      setState(() => fullName = newVal);
                    }),
                  ),
                  _buildEditableField(
                    label: 'Email',
                    value: email,
                    onEdit: () => _editField('Email', email, false, (newVal) {
                      setState(() => email = newVal);
                    }),
                  ),
                  _buildEditableField(
                    label: 'Phone Number',
                    value: phoneNumber,
                    onEdit: () => _editField('Phone Number', phoneNumber, false, (newVal) {
                      setState(() => phoneNumber = newVal);
                    }),
                  ),
                  _buildEditableField(
                    label: 'Bio',
                    value: bio,
                    isMultiline: true,
                    onEdit: () => _editField('Bio', bio, true, (newVal) {
                      setState(() => bio = newVal);
                    }),
                  ),
                  _buildEditableField(
                    label: 'Workplace',
                    value: workplace,
                    isMultiline: true,
                    onEdit: () => _editField('Workplace', workplace, false, (newVal) {
                      setState(() => workplace = newVal);
                    }),
                  ),
                  _buildEditableField(
                    label: 'Living City',
                    value: city,
                    onEdit: () => _editField('Living City', city, false, (newVal) {
                      setState(() => city = newVal);
                    }),
                  ),
                  _buildSocialMediaSection(),
                ],
              ),
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

    final paintBlue = Paint()..color = pastelBlue..style = PaintingStyle.fill;
    final paintPink = Paint()..color = pastelPink..style = PaintingStyle.fill;

    Path path1 = Path();
    path1.moveTo(0, size.height * 0.1);
    path1.quadraticBezierTo(size.width * 0.2, size.height * 0.0,
        size.width * 0.4, size.height * 0.15);
    path1.quadraticBezierTo(size.width * 0.6, size.height * 0.3,
        size.width * 0.2, size.height * 0.35);
    path1.quadraticBezierTo(size.width * 0.05, size.height * 0.4, 0, size.height * 0.35);
    path1.close();
    canvas.drawPath(path1, paintBlue);

    Path path2 = Path();
    path2.moveTo(size.width, size.height * 0.9);
    path2.quadraticBezierTo(size.width * 0.8, size.height * 1.0,
        size.width * 0.6, size.height * 0.85);
    path2.quadraticBezierTo(size.width * 0.4, size.height * 0.7,
        size.width * 0.8, size.height * 0.65);
    path2.quadraticBezierTo(size.width * 0.95, size.height * 0.6,
        size.width, size.height * 0.65);
    path2.close();
    canvas.drawPath(path2, paintPink);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

