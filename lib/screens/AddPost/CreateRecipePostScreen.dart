import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final TextEditingController _servingCountController = TextEditingController();
  final TextEditingController _ingredientNameController =
      TextEditingController();
  final TextEditingController _ingredientQuantityController =
      TextEditingController();
  // final TextEditingController _cookingDescriptionController =
  //     TextEditingController();

  String? _difficulty;
  List<Map<String, dynamic>> _ingredients = [];
  List<Map<String, dynamic>> _steps = [];
  Map<String, int> _nutritionData = {};

  void _handleNutritionData(Map<String, int> data) {
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
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.height * 0.5,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'Title: ${_titleController.text.isNotEmpty ? _titleController.text : 'No title provided'}'),
                      const SizedBox(height: 8),
                      if (_descriptionController.text.isNotEmpty)
                        Text('Description: ${_descriptionController.text}'),
                      const SizedBox(height: 8),
                      Text(
                          'Difficulty: ${_difficulty ?? 'No difficulty level selected'}'),
                      const SizedBox(height: 16),
                      const SizedBox(height: 16),
                      const Text('Ingredients:'),
                      if (_ingredients.isNotEmpty)
                        ..._ingredients.map((ingredient) => Text(
                            '- ${ingredient['name']} (${ingredient['quantity']})'))
                      else
                        const Text('No ingredients added.'),
                      const SizedBox(height: 16),
                      const Text('How to cook:'),
                      // if (_cookingDescriptionController.text.isNotEmpty)
                      //   Text(_cookingDescriptionController.text)
                      // else
                      //   const Text('No cooking instructions provided.'),
                      const SizedBox(height: 16),
                      const Text('Steps:'),
                      if (_steps.isNotEmpty)
                        ..._steps.map((step) => Text(
                            '- ${step['description']} (time: ${step['time']} min)'))
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
    final jsonData = jsonEncode(postData);

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
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _createPost() async {
    if (_formKey.currentState!.validate()) {
      if (_ingredients.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please add at least one ingredient.')),
        );
        return;
      }

      final supabase = Supabase.instance.client;

      final postData = {
        'user_id': 'd942d7d5-f9b5-4dc6-a63d-7271f1e22f3a',
        'title': _titleController.text,
        'description': _descriptionController.text,
        'difficulty': _difficulty,
        'total_duration':
            _steps.fold(0, (sum, step) => sum + step['time'] as int),
        'serving_count': int.tryParse(_servingCountController.text) ?? 1,
      };

      try {
        // Insert the main recipe and get the recipe_id
        final response = await supabase
            .from('recipes')
            .insert(postData)
            .select('id')
            .single();

        final recipeId = response['id'];
        debugPrint('Recipe created with ID: $recipeId');

        // Insert nutrition data
        final nutritionData = {
          'recipe_id': recipeId,
          'protein': _nutritionData['Protein'],
          'carbs': _nutritionData['Carbs'],
          'fat': _nutritionData['Fat'],
        };

        final nutritionResponse =
            await supabase.from('nutrition').insert(nutritionData);
        print(nutritionResponse);

        // Insert ingredients
        for (final ingredient in _ingredients) {
          final ingredientResponse = await supabase.from('ingredients').insert({
            'recipe_id': recipeId,
            'name': ingredient['name'],
            'quantity': ingredient['quantity'],
            'unit': ingredient['unit'],
          });

          print(ingredientResponse);
        }

        // Insert steps with step_order
        for (int i = 0; i < _steps.length; i++) {
          final step = _steps[i];
          final stepResponse = await supabase.from('steps').insert({
            'recipe_id': recipeId,
            'description': step['description'],
            'time': step['time'],
            'step_order': i + 1,
          });

          print(stepResponse);
        }

        Navigator.pop(context, postData);
        _showPostCreatedDialog(postData);
      } catch (e) {
        debugPrint('Exception occurred during post creation: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create post: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF7DA9CE),
        title: const Text('Create Recipe Post'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.preview),
            onPressed: _showPreview,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white.withOpacity(0.9),
              const Color(0xFFEEF4FA),
              const Color(0xFFE6EDF8),
              const Color(0xFFE1EBF4),
              const Color(0xFFD1E0ED),
              const Color(0xFFD0DFF0),
            ],
          ),
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _titleController,
                  cursorColor: Colors.black,
                  decoration: const InputDecoration(
                    labelText: 'Recipe Title*',
                    labelStyle: TextStyle(color: Colors.black),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Title is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  dropdownColor: const Color(0xFFD0DFF0),
                  decoration: const InputDecoration(
                    labelText: 'Difficulty*',
                    labelStyle: TextStyle(color: Colors.black),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1),
                    ),
                  ),
                  value: _difficulty,
                  onChanged: (value) => setState(() => _difficulty = value),
                  items: ['Easy', 'Moderate', 'Cook Like a Pro']
                      .map((level) => DropdownMenuItem(
                            value: level,
                            child: Text(level),
                          ))
                      .toList(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Difficulty is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ImageUploader(onImageSelected: _handleImageSelection),
                const SizedBox(height: 16),
                if (_recipeImage != null)
                  const Text('Image successfully uploaded!'),
                const SizedBox(height: 16),
                VideoUploader(onVideoSelected: _handleVideoSelection),
                const SizedBox(height: 16),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  cursorColor: Colors.black,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: "Brief Description about the recipe",
                    labelStyle: TextStyle(color: Colors.black),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1),
                    ),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _servingCountController,
                  cursorColor: Colors.black,
                  decoration: const InputDecoration(
                    labelText: 'Number of Servings',
                    labelStyle: TextStyle(color: Colors.black),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (value) {
                    if (value.isEmpty) {
                      _servingCountController.text = '1';
                    }
                  },
                ),
                // TextFormField(
                //   controller: _ingredientsCountController,
                //   cursorColor: Colors.black,
                //   decoration: const InputDecoration(
                //     labelText: 'Number of Ingredients*',
                //     labelStyle: TextStyle(color: Colors.black),
                //     focusedBorder: UnderlineInputBorder(
                //       borderSide: BorderSide(color: Colors.black, width: 1),
                //     ),
                //   ),
                //   keyboardType: TextInputType.number,
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return 'Number of ingredients is required';
                //     }
                //     if (int.tryParse(value) == null) {
                //       return 'Enter a valid number';
                //     }
                //     return null;
                //   },
                // ),
                const SizedBox(height: 16),
                IngredientsList(onChanged: _handleIngredients),
                const SizedBox(height: 16),
                NutritionInput(onChanged: _handleNutritionData),
                const SizedBox(height: 8),
                // const SizedBox(height: 16),
                // TextFormField(
                //   controller: _cookingDescriptionController,
                //   cursorColor: Colors.black,
                //   decoration: const InputDecoration(
                //     labelText: 'How to Cook*',
                //     labelStyle: TextStyle(color: Colors.black),
                //     focusedBorder: UnderlineInputBorder(
                //       borderSide: BorderSide(color: Colors.black, width: 1),
                //     ),
                //   ),
                //   maxLines: 3,
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return 'Please provide how to cook';
                //     }

                //     return null;
                //   },
                // ),
                // const SizedBox(height: 16),
                StepsInput(onChanged: _handleSteps),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _createPost,
                  child: const Text('Create Post'),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF7DA9CE),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
