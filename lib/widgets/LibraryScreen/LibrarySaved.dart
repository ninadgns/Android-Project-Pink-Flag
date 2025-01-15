import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/RecipeModel.dart';
import '../../screens/AddPost/fetchRecipes.dart';
import '../Recipe/MealItem.dart';

class LibrarySaved extends StatefulWidget {
  const LibrarySaved({super.key});

  @override
  State<LibrarySaved> createState() => _LibrarySavedState();
}

class _LibrarySavedState extends State<LibrarySaved> {
  late List<Recipe> _recipeList = [];
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _fetchAndSetRecipes();
  }

  void _fetchAndSetRecipes() async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });
    List<dynamic> savedRecipesResponse = await Supabase.instance.client
        .from('saved_recipes')
        .select('recipe_id')
        .eq('user_id', FirebaseAuth.instance.currentUser!.uid);
    List<String> savedRecipes = savedRecipesResponse
        .map((item) => item['recipe_id'] as String)
        .toList();
    List<Map<String, dynamic>> response = await fetchRecipes();
    final converted = parseRecipes(response);
    converted.retainWhere((element) => savedRecipes.contains(element.id));

    setState(() {
      _recipeList = converted;
      _isLoading = false; // Hide loading indicator
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    if (_isLoading) {
      return Center(
          child: Column(
        children: [
          SizedBox(height: height * 0.04),
          CircularProgressIndicator(),
          SizedBox(height: height * 0.02),
          Text("Loading recipes..."),
        ],
      ));
    }

    if (_recipeList.isEmpty) {
      return Center(
          child: Column(
        children: [
          SizedBox(height: height * 0.04),
          SizedBox(height: height * 0.2),
          Text("No recipes found"),
        ],
      ));
    }

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          ..._recipeList.map((recipe) {
            return MealItem(
              recipe: recipe,
            );
          }),
          SizedBox(height: height * 0.15)
        ],
      ),
    );
  }
}
