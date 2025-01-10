import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class RecipeForm extends StatefulWidget {
  const RecipeForm({super.key});

  @override
  State<RecipeForm> createState() => _RecipeFormState();
}

class _RecipeFormState extends State<RecipeForm> {
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  String? _uploadedImageUrl;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImageToSupabase(File image) async {
    try {
      final supabase = Supabase.instance.client;
      final uuid = const Uuid().v4(); // Unique image name
      final imagePath = 'recipes/$uuid.png';

      // Upload image to Supabase storage bucket
      final response =
          await supabase.storage.from('recipe-images').upload(imagePath, image);

      debugPrint(response);

      // Get public URL of the uploaded image
      final imageUrl =
          supabase.storage.from('recipe-images').getPublicUrl(imagePath);

      debugPrint('Image uploaded: $imageUrl');
      return imageUrl;
    } catch (e) {
      debugPrint('Failed to upload image: $e');
      return null;
    }
  }

  Future<void> _createPost() async {
    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields')),
      );
      return;
    }

    // Upload image
    final imageUrl = await _uploadImageToSupabase(_selectedImage!);
    if (imageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to upload image')),
      );
      return;
    }

    // Prepare post data
    final postData = {
      'user_id': 'd942d7d5-f9b5-4dc6-a63d-7271f1e22f3a',
      'title': _titleController.text,
      'description': _descriptionController.text,
      'difficulty': 'Easy',
      'total_duration': 30,
      'serving_count': 2,
      'image_url': imageUrl, // Save image URL to recipes table
    };

    try {
      final supabase = Supabase.instance.client;

      final response =
          await supabase.from('recipes').insert(postData).select('id').single();

      debugPrint('Recipe created with ID: ${response['id']}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post created successfully')),
      );
        } catch (e) {
      debugPrint('Failed to create post: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create post: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Recipe')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 16),
            _selectedImage == null
                ? const Text('No image selected')
                : Image.file(_selectedImage!, height: 150),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.image),
              label: const Text('Select Image'),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _createPost,
              child: const Text('Create Post'),
            ),
          ],
        ),
      ),
    );
  }
}
