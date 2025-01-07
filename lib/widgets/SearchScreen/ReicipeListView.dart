import 'package:dim/data/constants.dart';
import 'package:dim/widgets/Recipe/MealItem.dart';
import 'package:flutter/material.dart';

class RecipeListView extends StatelessWidget {
  RecipeListView({super.key});
  final _recipeList = [
    dummyRecipe,
    dummyRecipe,
    dummyRecipe,
    dummyRecipe,
  ];
  @override
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
