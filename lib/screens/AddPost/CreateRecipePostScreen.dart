import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'steps_input.dart';
import 'video_uploader.dart';
import 'package:video_player/video_player.dart';
import 'image_uploader.dart';
import 'nutrition_input.dart';
import 'ingredients_list.dart';

class CreateRecipePostScreen extends StatefulWidget {
  const CreateRecipePostScreen({super.key});

  @override
  State<CreateRecipePostScreen> createState() => _CreateRecipePostScreenState();
}

class _CreateRecipePostScreenState extends State<CreateRecipePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _nutritionController = TextEditingController();
  final TextEditingController _ingredientsCountController =
  TextEditingController();
  final TextEditingController _servingCountController =
  TextEditingController();
  final TextEditingController _ingredientNameController =
  TextEditingController();
  final TextEditingController _ingredientQuantityController =
  TextEditingController();
  final TextEditingController _cookingDescriptionController =
  TextEditingController();

  String? _category;
  List<Map<String, dynamic>> _ingredients = [];
  List<Map<String, dynamic>> _steps = [];
  Map<String, dynamic> _nutritionData = {};

  void _handleNutritionData(Map<String, dynamic> data) {
    setState(() {
      _nutritionData = data;
    });
  }



  Uint8List? _recipeImage; // Use Uint8List instead of File
  final ImagePicker _picker = ImagePicker();
  XFile? _recipeVideo; // For video upload
  VideoPlayerController? _videoController;

  void _handleImageSelection(Uint8List? imageBytes) {
    setState(() {
      _recipeImage = imageBytes;
    });
  }

  void _handleVideoSelection(XFile? video) {
    setState(() {
      _recipeVideo = video;
    });
  }

  void _handleIngredients(List<Map<String, dynamic>> ingredients) {
    setState(() {
      _ingredients = ingredients;
    });
  }

  void _handleSteps(List<Map<String, dynamic>> steps) {
    setState(() {
      _steps = steps;
    });
  }


  void _showPreview() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.5, // 90% of screen width
          height: MediaQuery.of(context).size.height * 0.5, // 80% of screen height
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Title: ${_titleController.text.isNotEmpty ? _titleController.text : 'No title provided'}'),
                      const SizedBox(height: 8),
                      if (_descriptionController.text.isNotEmpty)
                        Text('Description: ${_descriptionController.text}'),
                      const SizedBox(height: 8),
                      Text('Category: ${_category ?? 'No category selected'}'),
                      const SizedBox(height: 16),
                      const SizedBox(height: 16),
                      Text('Ingredients:'),
                      if (_ingredients.isNotEmpty)
                        ..._ingredients.map((ingredient) => Text(
                            '- ${ingredient['name']} (${ingredient['quantity']})'))
                      else
                        const Text('No ingredients added.'),
                      const SizedBox(height: 16),
                      Text('How to cook:'),
                      if (_cookingDescriptionController.text.isNotEmpty)
                        Text(_cookingDescriptionController.text)
                      else
                        const Text('No cooking instructions provided.'),
                      const SizedBox(height: 16),
                      Text('Steps:'),
                      if (_steps.isNotEmpty)
                        ..._steps.map((step) => Text(
                            '- ${step['description']} (Timing: ${step['timing']} min)'))
                      else
                        const Text('No steps added.'),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  void _showPostCreatedDialog(Map<String, dynamic> postData) {
    final jsonData = jsonEncode(postData); // Convert post data to JSON format

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Post Created'),
        content: SingleChildScrollView(
          child: Text(
            jsonData,
            style: const TextStyle(fontSize: 14),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Close the dialog
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _createPost() {
    // Validate the form first
    if (_formKey.currentState!.validate()) {
      // Check additional constraints
      if (_ingredients.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please add at least one ingredient.')),
        );
        return;
      }

      if (_cookingDescriptionController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please provide the cooking instructions.')),
        );
        return;
      }

      // If all checks pass, create the post
      final postData = {
        'title': _titleController.text,
        'description': _descriptionController.text,
        'category': _category,
        'nutrition': _nutritionData,
        'ingredients': _ingredients,
        'steps': _steps,
      };
      Navigator.pop(context, postData); // Return post data
      _showPostCreatedDialog(postData);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Recipe Post'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.preview),
            onPressed: _showPreview,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Recipe Title*'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Title is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Category*'),
                value: _category,
                onChanged: (value) => setState(() => _category = value),
                items: ['Easy', 'Moderate', 'Cook Like a Pro']
                    .map((level) => DropdownMenuItem(
                  value: level,
                  child: Text(level),
                ))
                    .toList(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Category is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ImageUploader(onImageSelected: _handleImageSelection),
              const SizedBox(height: 16),
              if (_recipeImage != null) const Text('Image successfully uploaded!'),


              const SizedBox(height: 16),
              VideoUploader(onVideoSelected: _handleVideoSelection),
              const SizedBox(height: 16),


              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _servingCountController,
                decoration: const InputDecoration(labelText: 'Number of Servings'),
                keyboardType: TextInputType.number,

                onChanged: (value) {
                  if (value.isEmpty) {
                    _servingCountController.text = '1'; // Set default to 1 if empty
                  }
                },
              ),

              TextFormField(
                controller: _ingredientsCountController,
                decoration:
                const InputDecoration(labelText: 'Number of Ingredients*'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Number of ingredients is required';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              IngredientsList(onChanged: _handleIngredients),
              const SizedBox(height: 16),

              NutritionInput(onChanged: _handleNutritionData),
              const SizedBox(height: 8),

              const SizedBox(height: 16),
              TextFormField(
                controller: _cookingDescriptionController,
                decoration: const InputDecoration(labelText: 'How to Cook*'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please provide how to cook';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),
              StepsInput(onChanged: _handleSteps),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _createPost,
                child: const Text('Create Post'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
