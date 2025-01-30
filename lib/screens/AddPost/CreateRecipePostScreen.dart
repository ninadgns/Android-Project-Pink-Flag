import 'dart:convert';
import 'dart:io';
import 'package:dim/screens/HomeScreen.dart';
import 'package:dim/services/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'steps_input.dart';
import 'video_uploader.dart';
import 'package:video_player/video_player.dart';
import 'image_uploader.dart';
import 'nutrition_input.dart';
import 'ingredients_list.dart';
import 'package:uuid/uuid.dart';

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

  final supabase = Supabase.instance.client;

  String? _difficulty;
  List<Map<String, dynamic>> _ingredients = [];
  List<Map<String, dynamic>> _steps = [];
  Map<String, int> _nutritionData = {};

  void _handleNutritionData(Map<String, int> data) {
    setState(() {
      _nutritionData = data;
    });
  }

  File? _recipeImage; // Use Uint8List instead of File
  final ImagePicker _picker = ImagePicker();
  XFile? _recipeVideo; // For video upload
  VideoPlayerController? _videoController;

  void _handleImageSelection(File? imageFile) {
    setState(() {
      _recipeImage = imageFile;
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

  Future<String?> _uploadImageToSupabase(File image) async {
    try {
      final uuid = const Uuid().v4(); // Unique image name
      final imagePath = 'images/$uuid.png';

      // Upload image to Supabase storage bucket
      final response =
          await supabase.storage.from('recipe').upload(imagePath, image);

      debugPrint('Response: $response');

      // Get public URL of the uploaded image
      final imageUrl = supabase.storage.from('recipe').getPublicUrl(imagePath);

      debugPrint('Image uploaded: $imageUrl');
      return imageUrl;
    } catch (e) {
      debugPrint('Failed to upload image: $e');
      return null;
    }
  }

  Future<void> _createPost() async {
    if (_formKey.currentState!.validate()) {
      if (_ingredients.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please add at least one ingredient.')),
        );
        return;
      }

      final imageUrl = await _uploadImageToSupabase(_recipeImage!);

      final postData = {
        'user_id': FirebaseAuth.instance.currentUser!.uid,
        'title': _titleController.text,
        'description': _descriptionController.text,
        'difficulty': _difficulty,
        'total_duration':
            _steps.fold(0, (sum, step) => sum + step['time'] as int),
        'serving_count': int.tryParse(_servingCountController.text) ?? 1,
        'title_photo': imageUrl,
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
          'protein': _nutritionData['Protein'] ?? 0,
          'carbs': _nutritionData['Carbs'] ?? 0,
          'fat': _nutritionData['Fat'] ?? 0,
        };

        final nutritionResponse =
            await supabase.from('nutrition').insert(nutritionData);
        debugPrint(nutritionResponse);

        // Insert ingredients
        final List<Map<String, dynamic>> ingredientBatch =
            _ingredients.map((ingredient) {
          return {
            'recipe_id': recipeId,
            'name': ingredient['name'],
            'quantity': ingredient['quantity'],
            'unit': ingredient['unit'],
          };
        }).toList();

        if (ingredientBatch.isNotEmpty) {
          final ingredientsResponse =
              await supabase.from('ingredients').insert(ingredientBatch);
          debugPrint(ingredientsResponse);
        }

        // Batch insert steps
        final List<Map<String, dynamic>> stepsBatch =
            _steps.asMap().entries.map((entry) {
          final step = entry.value;
          return {
            'recipe_id': recipeId,
            'description': step['description'],
            'time': step['time'],
            'step_order': entry.key + 1,
          };
        }).toList();

        if (stepsBatch.isNotEmpty) {
          final stepResopnse = await supabase.from('steps').insert(stepsBatch);
          debugPrint(stepResopnse);
        }

        // Navigator.pop(context, postData);
        _showPostCreatedDialog(postData);
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Homescreen(),
          ),
        );
      } catch (e) {
        debugPrint('Exception occurred during post creation: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create post: $e')),
        );
      }
    }
  }
  final List<String> difficultyLevels = ['Easy', 'Moderate', 'Hard'];

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
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: difficultyLevels.map((level) {
                    final isSelected = _difficulty == level;

                    return ChoiceChip(
                      label: Text(level),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      selected: isSelected,
                      selectedColor: const Color(0xFF7DA9CE),
                      backgroundColor: Colors.grey[200],
                      onSelected: (selected) {
                        setState(() {
                          _difficulty = selected ? level : null;
                        });
                      },
                    );
                  }).toList(),
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
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF7DA9CE),
                  ),
                  child: const Text('Create Post'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
