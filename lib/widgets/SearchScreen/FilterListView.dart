import 'package:dim/models/CollectionModel.dart';
import 'package:dim/screens/AddPost/fetchRecipes.dart';
import 'package:dim/widgets/Recipe/MealItem.dart';
import 'package:dim/widgets/SearchScreen/ReicipeListView.dart';
import 'package:flutter/material.dart';

import '../../models/RecipeModel.dart';

class Filterlistview extends StatefulWidget {
  final double sliderValue;
  final List<String> selectedDifficulty;
  final List<String> selectedDishType;

  const Filterlistview({
    required this.sliderValue,
    required this.selectedDifficulty,
    required this.selectedDishType,
  });
  @override
  State<Filterlistview> createState() => _RecipeListViewState();
}

class _RecipeListViewState extends State<Filterlistview> {
  bool _isLoading = true; // Start with loading state
  List<Recipe> recipeList = []; // Moved here for better encapsulation

  Future<void> fetchAndSetRecipes() async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      final response = await filterRecipes(
        widget.sliderValue,
        widget.selectedDifficulty,
        widget.selectedDishType,
      );
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
  void didUpdateWidget(Filterlistview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.sliderValue != widget.sliderValue ||
        oldWidget.selectedDifficulty != widget.selectedDifficulty ||
        oldWidget.selectedDishType != widget.selectedDishType) {
      fetchAndSetRecipes();
    }
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
