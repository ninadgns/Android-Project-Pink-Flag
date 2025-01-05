// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dim/screens/AddPost/image_uploader.dart';
// import 'package:dim/screens/AddPost/video_uploader.dart';
// import 'package:flutter/material.dart';

// class RecipeForm extends StatefulWidget {
//   @override
//   _RecipeFormState createState() => _RecipeFormState();
// }

// class _RecipeFormState extends State<RecipeForm> {
//   final _formKey = GlobalKey<FormState>();

//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//   final TextEditingController _servingCountController = TextEditingController();
//   final TextEditingController _ingredientsCountController =
//       TextEditingController();
//   final TextEditingController _cookingDescriptionController =
//       TextEditingController();
//   final TextEditingController _stepsController = TextEditingController();

//   String? _category;
//   String? _recipeImage;
//   String? _recipeVideo;
//   List<String> _ingredients = [];
//   Map<String, dynamic> _nutritionData = {};

//   void _handleImageSelection(String? imageUrl) {
//     setState(() {
//       _recipeImage = imageUrl;
//     });
//   }

//   void _handleVideoSelection(String? videoUrl) {
//     setState(() {
//       _recipeVideo = videoUrl;
//     });
//   }

//   void _handleIngredients(List<String> ingredients) {
//     setState(() {
//       _ingredients = ingredients;
//     });
//   }

//   void _handleNutritionData(Map<String, dynamic> nutritionData) {
//     setState(() {
//       _nutritionData = nutritionData;
//     });
//   }

//   Future<void> _createPost() async {
//     if (_formKey.currentState!.validate()) {
//       final recipeData = {
//         'title': _titleController.text,
//         'category': _category,
//         'description': _descriptionController.text,
//         'servings': int.tryParse(_servingCountController.text) ?? 1,
//         'ingredientsCount': int.tryParse(_ingredientsCountController.text),
//         'cookingDescription': _cookingDescriptionController.text,
//         'steps': _stepsController.text,
//         'ingredients': _ingredients,
//         'nutrition': _nutritionData,
//         'image': _recipeImage,
//         'video': _recipeVideo,
//         'createdAt': Timestamp.now(),
//       };

//       try {
//         await FirebaseFirestore.instance.collection('recipes').add(recipeData);
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Recipe successfully created!')),
//         );
//         _formKey.currentState!.reset();
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to create recipe: $e')),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: _formKey,
//       child: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TextFormField(
//               controller: _titleController,
//               decoration: const InputDecoration(labelText: 'Recipe Title*'),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Title is required';
//                 }
//                 return null;
//               },
//             ),
//             const SizedBox(height: 16),
//             DropdownButtonFormField<String>(
//               decoration: const InputDecoration(labelText: 'Category*'),
//               value: _category,
//               onChanged: (value) => setState(() => _category = value),
//               items: ['Easy', 'Moderate', 'Cook Like a Pro']
//                   .map((level) => DropdownMenuItem(
//                         value: level,
//                         child: Text(level),
//                       ))
//                   .toList(),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Category is required';
//                 }
//                 return null;
//               },
//             ),
//             const SizedBox(height: 16),
//             ImageUploader(onImageSelected: _handleImageSelection),
//             const SizedBox(height: 16),
//             if (_recipeImage != null)
//               const Text('Image successfully uploaded!'),
//             const SizedBox(height: 16),
//             VideoUploader(onVideoSelected: _handleVideoSelection),
//             const SizedBox(height: 16),
//             TextFormField(
//               controller: _descriptionController,
//               decoration: const InputDecoration(labelText: 'Description'),
//               maxLines: 3,
//             ),
//             const SizedBox(height: 16),
//             TextFormField(
//               controller: _servingCountController,
//               decoration:
//                   const InputDecoration(labelText: 'Number of Servings'),
//               keyboardType: TextInputType.number,
//             ),
//             TextFormField(
//               controller: _ingredientsCountController,
//               decoration:
//                   const InputDecoration(labelText: 'Number of Ingredients*'),
//               keyboardType: TextInputType.number,
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Number of ingredients is required';
//                 }
//                 if (int.tryParse(value) == null) {
//                   return 'Enter a valid number';
//                 }
//                 return null;
//               },
//             ),
//             const SizedBox(height: 16),
//             IngredientsList(onChanged: _handleIngredients),
//             const SizedBox(height: 16),
//             NutritionInput(onChanged: _handleNutritionData),
//             const SizedBox(height: 8),
//             TextFormField(
//               controller: _cookingDescriptionController,
//               decoration: const InputDecoration(labelText: 'How to Cook*'),
//               maxLines: 3,
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please provide how to cook';
//                 }
//                 return null;
//               },
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: _createPost,
//               child: const Text('Create Post'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
