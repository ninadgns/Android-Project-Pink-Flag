import 'package:dim/screens/AddPost/fetchRecipes.dart';
import 'package:dim/widgets/Recipe/MealItem.dart';
import 'package:dim/widgets/SearchScreen/ReicipeListView.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/RecipeModel.dart';

class IngredientFilterList extends StatefulWidget {
  const IngredientFilterList({
    super.key,
  });
  @override
  State<IngredientFilterList> createState() => _RecipeListViewState();
}

class _RecipeListViewState extends State<IngredientFilterList> {
  bool _isLoading = true; // Start with loading state
  List<Recipe> recipeList = []; // Moved here for better encapsulation

  Future<void> fetchAndSetRecipes() async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      final response =
          await findMatchingRecipes(FirebaseAuth.instance.currentUser!.uid);
      final parsedRecipes = parseRecipes(response);
      setState(() {
        recipeList = parsedRecipes;
      });
    } catch (e) {
      debugPrint('Error fetching recipes: $e');
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAndSetRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Results'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _isLoading
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text("Loading recipes..."),
                  ],
                ),
              )
            : recipeList.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("No recipes found"),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: recipeList.length,
                    itemBuilder: (ctx, index) {
                      final recipe = recipeList[index];
                      return MealItem(
                        recipe: recipe,
                        collections: collectionsList.value,
                      );
                    },
                  ),
      ),
    );
  }
}
