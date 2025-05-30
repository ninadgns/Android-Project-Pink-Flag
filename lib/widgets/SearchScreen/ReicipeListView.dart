import 'package:dim/models/CollectionModel.dart';
// import 'package:dim/models/GroceryModel.dart';
import 'package:dim/screens/AddPost/fetchRecipes.dart';
import 'package:dim/widgets/Recipe/MealItem.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/RecipeModel.dart';

class RecipeListView extends StatefulWidget {
  final String searchQuery;
  RecipeListView({super.key, required this.searchQuery});

  @override
  State<RecipeListView> createState() => _RecipeListViewState();
}

Future<List<CollectionModelItem>> fetchCollections() async {
  final supabase = Supabase.instance.client;
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    throw Exception('User not logged in');
  }

  try {
    final response = await supabase
        .from('collections')
        .select('id, collection_name')
        .eq('user_id', user.uid);

    if (response.isEmpty) {
      debugPrint('No collections found for user: ${user.uid}');
      return [];
    }

    final collections = response
        .map((collection) => {
              'id': collection['id'],
              'collection_name': collection['collection_name']
            })
        .toList();
    debugPrint('Collections fetched successfully for user: ${user.uid}');
    List<CollectionModelItem> collectionList = collections
        .map((collection) => CollectionModelItem(
            id: collection['id'], name: collection['collection_name']))
        .toList();
    // print(collections);
    return collectionList;
  } catch (e) {
    debugPrint('Failed to fetch collections for user ${user.uid}: $e');
    throw Exception('Failed to fetch collections for the user.');
  }
}

ValueNotifier<List<CollectionModelItem>> collectionsList = ValueNotifier([]);
void addCollectionItem(CollectionModelItem collection) {
  collectionsList.value.add(collection);
  // collectionsList.notifyListeners();
}

List<Recipe> recipeList = [];

class _RecipeListViewState extends State<RecipeListView> {
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _fetchAndSetRecipes(widget.searchQuery);
    _initialize();
  }

  Future<void> _initialize() async {
    // await fetchCollections();
    collectionsList.value = await fetchCollections();
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
      recipeList = converted;
      _isLoading = false; // Hide loading indicator
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(
          child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.2),
          Text("Loading recipes..."),
        ],
      ));
    }

    if (recipeList.isEmpty) {
      return Center(
          child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.2),
          Text("No recipes found"),
        ],
      ));
    }

    return Column(
      children: recipeList.map((recipe) {
        return MealItem(
          recipe: recipe,
          collections: collectionsList.value,
        );
      }).toList(),
    );
  }
}
