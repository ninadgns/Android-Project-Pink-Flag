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
    List<Map<String, dynamic>> response;
    if (query.isEmpty) {
      // Call fetchRecipes if searchQuery is empty
      response = await fetchRecipes();
    } else {
      // Call searchRecipesByPrompt if searchQuery is not empty
      response = await searchRecipesByPrompt(query);
    }

    // Convert response to Recipe objects
    final converted = parseRecipes(response);
    setState(() {
      _recipeList = converted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _recipeList.isEmpty
          ? [Center(child: Text("No recipes found"))]
          : _recipeList.map((recipe) {
              return MealItem(
                recipe: recipe,
              );
            }).toList(),
    );
  }
}
