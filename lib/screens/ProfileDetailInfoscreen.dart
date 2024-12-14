import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';

class ProfileDetailInfoscreen extends StatefulWidget {
  const ProfileDetailInfoscreen({super.key});

  @override
  State<ProfileDetailInfoscreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<ProfileDetailInfoscreen> {
  String profileImagePath = 'assets/images/profile.png';
  String fullName = 'Sofia Anderson';
  String email = 'sofia@example.com';
  String phoneNumber = '+1 234 567 8900';
  String bio = 'Food lover, cook, and traveler.';
  String city = 'New York';
  String workplace = 'Culinary Institute of America';

  List<Map<String, String>> socialMediaIds = [
    {'platform': 'Instagram', 'handle': '@sofiacooks'},
    {'platform': 'Twitter', 'handle': '@sofiatravels'},
  ];

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        profileImagePath = pickedFile.path;
      });
    }
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
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: highlight ? Colors.blue[50] : Colors.grey[200],
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        crossAxisAlignment: isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: isMultiline ? 12.0 : 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.bold)),
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
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Social Media', style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Column(
            children: socialMediaIds.map((platform) {
              return Row(
                children: [
                  Expanded(
                    child: Text('${platform['platform']}: ${platform['handle']}', style: const TextStyle(fontSize: 16)),
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
                  platform['handle'] = controller.text;
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
                if (platformController.text.isNotEmpty && handleController.text.isNotEmpty) {
                  setState(() {
                    socialMediaIds.add({
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
    const profileLink = 'https://example.com/users/sofia';
    Share.share('Check out my profile: $profileLink');
  }

  Widget _buildStat(String number, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(number, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.grey[600])),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text('My Profile', style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.black),
            onPressed: _shareProfile,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: profileImagePath.startsWith('assets/')
                        ? AssetImage(profileImagePath)
                        : FileImage(File(profileImagePath)) as ImageProvider,
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
                        child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
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
                color: Colors.white,
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
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              ),
              child: const Text(
                'Save Changes',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
