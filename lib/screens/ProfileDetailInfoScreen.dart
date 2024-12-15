import 'dart:io' show File; // This will be conditionally used only on mobile.
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

  String fullName = 'Sofia Anderson';
  String email = 'sofia@example.com';
  String phoneNumber = '+1 234 567 8900';
  String bio = 'Food lover, cook, and traveler.';
  String city = 'New York';
  String workplace = 'Culinary Institute of America';

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
          title: Text('Edit $fieldName'),
          content: TextField(
            controller: controller,
            keyboardType: multiline ? TextInputType.multiline : TextInputType.text,
            maxLines: multiline ? 3 : 1,
            decoration: InputDecoration(
              hintText: 'Enter new $fieldName',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                onSave(controller.text);
                Navigator.pop(context);
              },
              child: const Text('Save'),
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
    bool highlight = false,
    IconData icon = Icons.edit,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
      decoration: BoxDecoration(
        // A soothing pastel background for the field
        color: highlight ? const Color(0xFFE0F7FA).withOpacity(0.9) : Colors.grey[200],
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        crossAxisAlignment: isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical:  0),
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
            onPressed: onEdit,
          ),
        ],
      ),
    );
  }

  Widget _buildSocialMediaSection() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      decoration: BoxDecoration(
        // Soft pastel primary background
        color: const Color(0xFFE0F7FA).withOpacity(0.9),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Social Media',
              style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Column(
            children: socialMediaIds.map((platform) {
              return Row(
                children: [
                  Expanded(
                    child: Text('${platform['platform']}: ${platform['handle']}',
                        style: const TextStyle(fontSize: 16)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.grey),
                    onPressed: () {
                      _editSocialMediaHandle(platform);
                    },
                  ),
                ],
              );
            }).toList(),
          ),
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Could add a slight animation with TweenAnimationBuilder if needed
        Text(number,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.grey[600])),
      ],
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
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.share, color: Colors.black),
                        onPressed: _shareProfile,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text('My Profile',
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 24,
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
                  const SizedBox(height: 30),
                  _buildEditableField(
                    label: 'Full Name',
                    value: fullName,
                    highlight: true,
                    onEdit: () => _editField('Full Name', fullName, false, (newVal) {
                      setState(() => fullName = newVal);
                    }),
                  ),
                  _buildEditableField(
                    label: 'Email',
                    value: email,
                    highlight: true,
                    onEdit: () => _editField('Email', email, false, (newVal) {
                      setState(() => email = newVal);
                    }),
                  ),
                  _buildEditableField(
                    label: 'Phone Number',
                    value: phoneNumber,
                    highlight: true,
                    onEdit: () => _editField('Phone Number', phoneNumber, false, (newVal) {
                      setState(() => phoneNumber = newVal);
                    }),
                  ),
                  _buildEditableField(
                    label: 'Bio',
                    value: bio,
                    highlight: true,
                    isMultiline: true,
                    onEdit: () => _editField('Bio', bio, true, (newVal) {
                      setState(() => bio = newVal);
                    }),
                  ),
                  _buildEditableField(
                    label: 'Living City',
                    value: city,
                    highlight: true,
                    onEdit: () => _editField('Living City', city, false, (newVal) {
                      setState(() => city = newVal);
                    }),
                  ),
                  _buildEditableField(
                    label: 'Workplace',
                    value: workplace,
                    highlight: true,
                    onEdit: () => _editField('Workplace', workplace, false, (newVal) {
                      setState(() => workplace = newVal);
                    }),
                  ),
                  _buildSocialMediaSection(),
                  Container(
                    margin: const EdgeInsets.only(bottom: 24.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStat('23', 'Recipes'),
                        _buildStat('142', 'Following'),
                        _buildStat('98', 'Followers'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Save changes logic
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Changes saved!'),
                          backgroundColor: Colors.black87,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 32),
                    ),
                    child: const Text(
                      'Save Changes',
                      style: TextStyle(color: Colors.white, fontSize: 16),
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


class SoftPastelBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final pastelBlue = const Color(0xFFADD6CF).withOpacity(0.3);
    final pastelPink = const Color(0xFFF0AF9E).withOpacity(0.3);
    final pastelGreen = const Color(0xFF9FB693).withOpacity(0.3);
    final pastelYellow = const Color(0xFFF8E8C4).withOpacity(0.3);

    final paintBlue = Paint()..color = pastelBlue..style = PaintingStyle.fill;
    final paintPink = Paint()..color = pastelPink..style = PaintingStyle.fill;
    final paintGreen = Paint()..color = pastelGreen..style = PaintingStyle.fill;
    final paintYellow = Paint()..color = pastelYellow..style = PaintingStyle.fill;

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

