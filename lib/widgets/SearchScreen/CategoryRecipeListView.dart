import 'package:dim/models/CollectionModel.dart';
import 'package:dim/screens/AddPost/fetchRecipes.dart';
import 'package:dim/widgets/Recipe/MealItem.dart';
import 'package:flutter/material.dart';

import '../../models/RecipeModel.dart';

class CategoryRecipeListView extends StatefulWidget {
  final String category;
  const CategoryRecipeListView({super.key, required this.category});

  @override
  State<CategoryRecipeListView> createState() => _RecipeListViewState();
}

ValueNotifier<List<CollectionModelItem>> collectionsList = ValueNotifier([]);
void addCollectionItem(CollectionModelItem collection) {
  collectionsList.value.add(collection);
}

class _RecipeListViewState extends State<CategoryRecipeListView> {
  bool _isLoading = true; // Start with loading state
  List<Recipe> recipeList = []; // Moved here for better encapsulation

  Future<void> fetchAndSetRecipes() async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      final response = await fetchRecipesByTag(widget.category);
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
  void didUpdateWidget(CategoryRecipeListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.category != oldWidget.category) {
      fetchAndSetRecipes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.category} Recipes'),
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
