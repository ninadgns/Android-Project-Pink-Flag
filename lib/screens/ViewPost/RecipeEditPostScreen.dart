import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

// AddPost components
import '../AddPost/steps_input.dart';
import '../AddPost/video_uploader.dart';
import '../AddPost/image_uploader.dart';
import '../AddPost/nutrition_input.dart';
import '../AddPost/ingredients_list.dart';
import '../AddPost/CreateRecipePostScreen.dart';

// ViewPost components
import 'RecipeCard.dart';
import 'MyPostsScreen.dart';
import 'RecipePost.dart';

class EditRecipePostScreen extends StatefulWidget {
  final String recipeId;

  const EditRecipePostScreen({
    super.key,
    required this.recipeId
  });

  @override
  State<EditRecipePostScreen> createState() => _EditRecipePostScreenState();
}

class _EditRecipePostScreenState extends State<EditRecipePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _servingCountController = TextEditingController();

  final supabase = Supabase.instance.client;
  bool _isLoading = true;
  String? _error;
  String? _difficulty;
  List<Map<String, dynamic>> _ingredients = [];
  List<Map<String, dynamic>> _steps = [];
  Map<String, int> _nutritionData = {};
  File? _recipeImage;
  String? _existingImageUrl;
  final ImagePicker _picker = ImagePicker();
  XFile? _recipeVideo;

  @override
  void initState() {
    super.initState();
    _loadRecipeData();
  }

  Future<void> _loadRecipeData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // First debug point
      debugPrint('Fetching data for recipe ID: ${widget.recipeId}');

      final response = await supabase
          .from('recipes')
          .select('''
          id,
          title,
          description,
          difficulty,
          total_duration,
          serving_count,
          title_photo,
          nutrition!inner(protein, carbs, fat),
          ingredients!inner(name, quantity, unit),
          steps!inner(description, time, step_order)
        ''')
          .eq('id', widget.recipeId)
          .single();

      // Debug raw response
      debugPrint('Raw response: ${jsonEncode(response)}');

      if (mounted) {
        // Debug each section before processing
        debugPrint('Processing basic data...');
        try {
          _titleController.text = response['title'] ?? '';
          _descriptionController.text = response['description'] ?? '';
          _servingCountController.text = (response['serving_count'] ?? 1).toString();
          _difficulty = response['difficulty'];
          _existingImageUrl = response['title_photo'];
        } catch (e) {
          debugPrint('Error in basic data processing: $e');
          throw e;
        }

        // Debug nutrition data
        debugPrint('Processing nutrition data...');
        try {
          if (response['nutrition'] != null && response['nutrition'].isNotEmpty) {
            final nutritionData = response['nutrition'][0];
            debugPrint('Nutrition raw data: $nutritionData');
            _nutritionData = {
              'Protein': nutritionData['protein'] ?? 0,
              'Carbs': nutritionData['carbs'] ?? 0,
              'Fat': nutritionData['fat'] ?? 0,
            };
          }
        } catch (e) {
          debugPrint('Error in nutrition processing: $e');
          throw e;
        }

        // Debug ingredients
        debugPrint('Processing ingredients...');
        try {
          if (response['ingredients'] != null) {
            debugPrint('Ingredients raw data: ${response['ingredients']}');
            _ingredients = List<Map<String, dynamic>>.from(
                response['ingredients'].map((ing) {
                  debugPrint('Processing ingredient: $ing');
                  return {
                    'name': ing['name'] as String,
                    'quantity': (ing['quantity'] is int)
                        ? (ing['quantity'] as int).toDouble()
                        : (ing['quantity'] as num).toDouble(),
                    'unit': ing['unit'] as String,
                  };
                })
            );
          }
        } catch (e) {
          debugPrint('Error in ingredients processing: $e');
          throw e;
        }

        // Debug steps
        debugPrint('Processing steps...');
        try {
          if (response['steps'] != null) {
            debugPrint('Steps raw data: ${response['steps']}');
            var stepsData = List<Map<String, dynamic>>.from(
                response['steps'].map((step) {
                  debugPrint('Processing step: $step');
                  return {
                    'description': step['description'] as String,
                    'time': step['time'] is String
                        ? int.parse(step['time'])
                        : (step['time'] as num).toInt(),
                    'step_order': step['step_order'] is String
                        ? int.parse(step['step_order'])
                        : (step['step_order'] as num).toInt(),
                  };
                })
            );

            stepsData.sort((a, b) =>
                (a['step_order'] as int).compareTo(b['step_order'] as int)
            );
            _steps = stepsData;
          }
        } catch (e) {
          debugPrint('Error in steps processing: $e');
          throw e;
        }

        setState(() {
          _isLoading = false;
        });
      }

    } catch (e, stackTrace) {
      debugPrint('Error loading recipe: $e');
      debugPrint('Stack trace:');
      debugPrint(stackTrace.toString());
      if (mounted) {
        setState(() {
          _error = 'Error: ${e.toString()}\nLocation: ${stackTrace.toString().split('\n')[0]}';
          _isLoading = false;
        });
      }
    }
  }

  void _handleNutritionData(Map<String, int> data) {
    setState(() {
      _nutritionData = data;
    });
  }

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

  Future<String?> _uploadImageToSupabase(File image) async {
    try {
      final uuid = const Uuid().v4();
      final imagePath = 'images/$uuid.png';

      final response = await supabase.storage
          .from('recipe')
          .upload(imagePath, image);

      debugPrint('Response: $response');

      final imageUrl = supabase.storage
          .from('recipe')
          .getPublicUrl(imagePath);

      debugPrint('Image uploaded: $imageUrl');
      return imageUrl;
    } catch (e) {
      debugPrint('Failed to upload image: $e');
      return null;
    }
  }

  Future<void> _updateRecipe() async {
    if (_formKey.currentState!.validate()) {
      if (_ingredients.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please add at least one ingredient.')),
        );
        return;
      }

      try {
        String? imageUrl = _existingImageUrl;
        if (_recipeImage != null) {
          imageUrl = await _uploadImageToSupabase(_recipeImage!);
        }

        // Update main recipe data
        final recipeData = {
          'title': _titleController.text,
          'description': _descriptionController.text,
          'difficulty': _difficulty,
          'total_duration': _steps.fold(0, (sum, step) => sum + step['time'] as int),
          'serving_count': int.tryParse(_servingCountController.text) ?? 1,
          if (imageUrl != null) 'title_photo': imageUrl,
        };

        await supabase
            .from('recipes')
            .update(recipeData)
            .eq('id', widget.recipeId);

        // Update nutrition data
        await supabase
            .from('nutrition')
            .upsert({
          'recipe_id': widget.recipeId,
          'protein': _nutritionData['Protein'] ?? 0,
          'carbs': _nutritionData['Carbs'] ?? 0,
          'fat': _nutritionData['Fat'] ?? 0,
        });

        // Update ingredients
        await supabase
            .from('ingredients')
            .delete()
            .eq('recipe_id', widget.recipeId);

        if (_ingredients.isNotEmpty) {
          await supabase
              .from('ingredients')
              .insert(_ingredients.map((ingredient) => {
            'recipe_id': widget.recipeId,
            'name': ingredient['name'],
            'quantity': ingredient['quantity'],
            'unit': ingredient['unit'],
          }).toList());
        }

        // Update steps
        await supabase
            .from('steps')
            .delete()
            .eq('recipe_id', widget.recipeId);

        if (_steps.isNotEmpty) {
          await supabase
              .from('steps')
              .insert(_steps.asMap().entries.map((entry) => {
            'recipe_id': widget.recipeId,
            'description': entry.value['description'],
            'time': entry.value['time'],
            'step_order': entry.key + 1,
          }).toList());
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Recipe updated successfully')),
          );
          Navigator.pop(context, true);
        }
      } catch (e) {
        debugPrint('Error updating recipe: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update recipe: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Errorrr: $_error'),
              ElevatedButton(
                onPressed: _loadRecipeData,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF7DA9CE),
        title: const Text('Edit Recipe'),
        elevation: 0,
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
                  decoration: const InputDecoration(labelText: 'Recipe Title*'),
                  validator: (value) => value?.isEmpty ?? true ? 'Title is required' : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _difficulty,
                  decoration: const InputDecoration(labelText: 'Difficulty*'),
                  items: ['Easy', 'Moderate', 'Hard']
                      .map((level) => DropdownMenuItem(
                    value: level,
                    child: Text(level),
                  ))
                      .toList(),
                  onChanged: (value) => setState(() => _difficulty = value),
                  validator: (value) => value == null ? 'Difficulty is required' : null,
                ),
                const SizedBox(height: 16),
                ImageUploader(
                  onImageSelected: _handleImageSelection,
                  //initialImageUrl: _existingImageUrl,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: "Brief Description about the recipe",
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _servingCountController,
                  decoration: const InputDecoration(labelText: 'Number of Servings'),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                const SizedBox(height: 16),
                IngredientsList(
                  onChanged: _handleIngredients,
                  initialIngredients: _ingredients,
                ),
                const SizedBox(height: 16),
                NutritionInput(
                  onChanged: _handleNutritionData,
                  //initialData: _nutritionData,
                ),
                const SizedBox(height: 16),
                StepsInput(
                  onChanged: _handleSteps,
                  //initialSteps: _steps,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _updateRecipe,
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF7DA9CE),
                  ),
                  child: const Text('Update Recipe'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}