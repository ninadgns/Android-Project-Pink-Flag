import 'package:dim/data/constants.dart';
// import 'package:dim/models/GroceryModel.dart';
import 'package:dim/screens/AddPost/fetchRecipes.dart';
import 'package:dim/widgets/Recipe/MealItem.dart';
import 'package:flutter/material.dart';

import '../../models/RecipeModel.dart';

class RecipeListView extends StatefulWidget {
  RecipeListView({super.key});

  @override
  State<RecipeListView> createState() => _RecipeListViewState();
}

class _RecipeListViewState extends State<RecipeListView> {
  late List<Recipe> _recipeList = [];
  @override
  void initState() {
    super.initState();
    _fetchAndSetRecipes();
  }

  void _fetchAndSetRecipes() async {
    final response = await fetchRecipes();
    final converted = parseRecipes(response);
    // print(response[0]['title_photo']);
    setState(() {
      _recipeList = converted;
      // print(_recipeList[0].titlePhoto);
      // print(response[3]);
    });
  }  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ..._recipeList.map((recipe) {
          return MealItem(
            recipe: recipe,
          );
        }),
      ],
    );
  }
}
