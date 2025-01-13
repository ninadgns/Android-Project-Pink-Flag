import 'package:dim/data/constants.dart';
// import 'package:dim/models/GroceryModel.dart';
import 'package:dim/screens/AddPost/fetchRecipes.dart';
import 'package:dim/widgets/Recipe/MealItem.dart';
import 'package:flutter/material.dart';

import '../../models/RecipeModel.dart';

class RecipeListView extends StatefulWidget {
  final String searchQuery;
  RecipeListView({super.key, required this.searchQuery});

  @override
  State<RecipeListView> createState() => _RecipeListViewState();
}

class _RecipeListViewState extends State<RecipeListView> {
  late List<Recipe> _recipeList = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchAndSetRecipes(widget.searchQuery);
  }

  @override
  void didUpdateWidget(covariant RecipeListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchQuery != widget.searchQuery) {
      _fetchAndSetRecipes(widget.searchQuery);
    }
  }

  void _fetchAndSetRecipes(String query) async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    List<Map<String, dynamic>> response;
    if (query.isEmpty) {
      response = await fetchRecipes();
    } else {
      response = await searchRecipesByPrompt(query);
    }

    final converted = parseRecipes(response);

    setState(() {
      _recipeList = converted;
      _isLoading = false; // Hide loading indicator
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: Text("Loading recipes..."));
    }

    if (_recipeList.isEmpty) {
      return Center(child: Text("No recipes found"));
    }

    return Column(
      children: _recipeList.map((recipe) {
        return MealItem(
          recipe: recipe,
        );
      }).toList(),
    );
  }
}
