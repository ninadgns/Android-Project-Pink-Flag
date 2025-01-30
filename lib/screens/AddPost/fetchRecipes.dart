import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<List<Map<String, dynamic>>> fetchRecipes() async {
  final supabase = Supabase.instance.client;

  try {
    // Fetch all recipes with their related ingredients and steps
    final response = await supabase.from('recipes').select('''
          id,
          title,
          user_id,
          video_url,
          description,
          difficulty,
          total_duration,
          serving_count,
          created_at,
          title_photo,
          nutrition(protein, carbs, fat),
          ingredients(name, quantity, unit),
          steps(description, time, step_order)
        ''').order('created_at', ascending: false);

    if (response.isEmpty) {
      debugPrint('No recipes found.');
      return [];
    }

    debugPrint('Recipes fetched successfully.');
    print(response[0]['title_photo']);
    return List<Map<String, dynamic>>.from(response);
  } catch (e) {
    debugPrint('Failed to fetch recipes: $e');
    throw Exception('Failed to fetch recipes');
  }
}

Future<List<Map<String, dynamic>>> fetchRecipesGivenCategory() async {
  final supabase = Supabase.instance.client;

  try {
    // Fetch all recipes with their related ingredients and steps
    final response = await supabase.from('recipes').select('''
          id,
          title,
          user_id,
          description,
          video_url,
          difficulty,
          total_duration,
          serving_count,
          created_at,
          title_photo,
          nutrition(protein, carbs, fat),
          ingredients(name, quantity, unit),
          steps(description, time, step_order)
        ''').order('created_at', ascending: false);

    if (response.isEmpty) {
      debugPrint('No recipes found.');
      return [];
    }

    debugPrint('Recipes fetched successfully.');
    // debugPrint('Recipes: $response');
    print(response[0]['title_photo']);
    return List<Map<String, dynamic>>.from(response);
  } catch (e) {
    debugPrint('Failed to fetch recipes: $e');
    throw Exception('Failed to fetch recipes');
  }
}

Future<List<Map<String, dynamic>>> fullTextSearchRecipes(String prompt) async {
  final supabase = Supabase.instance.client;

  try {
    // Perform full-text search on the 'recipes' table's 'title' column
    final recipeResponse = await supabase.from('recipes').select('''
          id,
          title,
          user_id,
          description,
          video_url,
          difficulty,
          total_duration,
          serving_count,
          created_at,
          title_photo,
          nutrition(protein, carbs, fat),
          ingredients(name, quantity, unit),
          steps(description, time, step_order)
        ''').textSearch('title', prompt);

    debugPrint(
        'Recipes full-text search complete: ${recipeResponse.length} recipes found.');

    return List<Map<String, dynamic>>.from(recipeResponse);
  } catch (e) {
    debugPrint('Failed to perform full-text search on recipes: $e');
    throw Exception('Failed to search recipes');
  }
}

Future<List<Map<String, dynamic>>> fullTextSearchIngredients(
    String prompt) async {
  final supabase = Supabase.instance.client;

  try {
    // Perform full-text search on the 'ingredients' table's 'name' column
    final ingredientResponse = await supabase
        .from('ingredients')
        .select('recipe_id')
        .textSearch('name', prompt);

    if (ingredientResponse.isEmpty) {
      debugPrint(
          'No recipes found for ingredients with the search prompt: $prompt.');
      return [];
    }

    // Extract recipe IDs from the response
    final recipeIds = ingredientResponse
        .map((ingredient) => ingredient['recipe_id'])
        .toList();
    // Fetch corresponding recipes using the recipe IDs
    final recipesResponse = await supabase.from('recipes').select('''
          id,
          title,
          user_id,
          video_url,
          description,
          difficulty,
          total_duration,
          serving_count,
          created_at,
          title_photo,
          nutrition(protein, carbs, fat),
          ingredients(name, quantity, unit),
          steps(description, time, step_order)
        ''').inFilter('id', recipeIds);

    debugPrint(
        'Recipes fetched from ingredients search: ${recipesResponse.length} recipes found.');

    return List<Map<String, dynamic>>.from(recipesResponse);
  } catch (e) {
    debugPrint('Failed to perform full-text search on ingredients: $e');
    throw Exception('Failed to search ingredients');
  }
}

Future<List<Map<String, dynamic>>> searchRecipesByPrompt(String prompt) async {
  try {
    final recipesFromTitle = await fullTextSearchRecipes(prompt);
    final recipesFromIngredients = await fullTextSearchIngredients(prompt);

    // Combine and deduplicate recipes
    final combinedResults = [
      ...recipesFromTitle,
      ...recipesFromIngredients,
    ];
    final uniqueResults = {
      for (var recipe in combinedResults) recipe['id']: recipe
    }.values.toList();

    debugPrint(
        'Combined and deduplicated search results: ${uniqueResults.length} recipes found.');
    return uniqueResults;
  } catch (e) {
    debugPrint('Failed to search recipes and ingredients: $e');
    throw Exception('Failed to search recipes and ingredients');
  }
}

final supabase = Supabase.instance.client;

Future<List<Map<String, dynamic>>> fetchRecipesByTag(String tag) async {
  try {
    // Step 1: Fetch recipe IDs associated with the given tag\
    PostgrestList tagResponse;
    if (tag == 'Popular') {
      tagResponse = await supabase
          .from('tags')
          .select('recipe_id')
          .eq('is_popular', true);
    } else {
      tagResponse =
          await supabase.from('tags').select('recipe_id').eq('tag', tag);
    }
    if (tagResponse.isEmpty) {
      debugPrint('No recipes found for the tag: $tag.');
      return [];
    }

    // Extract recipe IDs from the response
    final recipeIds = tagResponse.map((tag) => tag['recipe_id']).toList();

    // Step 2: Fetch recipes using the recipe IDs
    final recipeResponse = await supabase.from('recipes').select('''
            id,
            title,
            video_url,
            user_id,
            description,
            difficulty,
            total_duration,
            serving_count,
            created_at,
            title_photo,
            nutrition(protein, carbs, fat),
            ingredients(name, quantity, unit),
            steps(description, time, step_order)
          ''').inFilter('id', recipeIds).order('created_at', ascending: false);

    if (recipeResponse.isEmpty) {
      debugPrint('No recipes found matching the tag: $tag.');
      return [];
    }

    debugPrint('Recipes fetched successfully for tag: $tag.');
    return List<Map<String, dynamic>>.from(recipeResponse);
  } catch (e) {
    debugPrint('Failed to fetch recipes for tag $tag: $e');
    throw Exception('Failed to fetch recipes for the given tag.');
  }
}

Future<List<Map<String, dynamic>>> filterRecipes(
  double sliderValue,
  List<String> selectedDifficulty,
  List<String> selectedDishType,
) async {
  try {
    PostgrestList initialResponse;
    if (sliderValue.toInt() == 0) {
      initialResponse = await supabase.from('recipes').select('id');
    } else {
      initialResponse = await supabase
          .from('recipes')
          .select('id')
          .lte('total_duration', sliderValue.toInt())
          .inFilter(
              'difficulty',
              selectedDifficulty.isEmpty
                  ? ['Easy', 'Medium', 'Like A Pro']
                  : selectedDifficulty);
    }
    if (initialResponse.isEmpty) {
      debugPrint('No recipes found for time: $sliderValue.');
      return [];
    }

    PostgrestList tagResponse;
    final recipeIds;
    if (selectedDishType.isEmpty) {
      tagResponse = initialResponse;
      recipeIds = tagResponse.map((tag) => tag['id']).toList();
    } else {
      tagResponse = await supabase
          .from('tags')
          .select('recipe_id')
          .inFilter(
              'recipe_id', initialResponse.map((tag) => tag['id']).toList())
          .inFilter('tag', selectedDishType);
      recipeIds = tagResponse.map((tag) => tag['recipe_id']).toList();
    }

    final recipeResponse = await supabase.from('recipes').select('''
            id,
            title,
            video_url,
            user_id,
            description,
            difficulty,
            total_duration,
            serving_count,
            created_at,
            title_photo,
            nutrition(protein, carbs, fat),
            ingredients(name, quantity, unit),
            steps(description, time, step_order)
          ''').inFilter('id', recipeIds).order('created_at', ascending: false);

    if (recipeResponse.isEmpty) {
      debugPrint('No recipes found with the given filters.');
      return [];
    }

    debugPrint('Recipes fetched successfully for the given filters.');
    return List<Map<String, dynamic>>.from(recipeResponse);
  } catch (e) {
    debugPrint('Failed to fetch recipes for given filters: $e');
    throw Exception('Failed to fetch recipes for the given tag.');
  }
}

Future<List<String>> fetchAvailableIngredients(String userId) async {
  // Initialize Supabase client
  final supabase = Supabase.instance.client;

  // Fetch data from the available_ingredients table
  final response = await supabase
      .from('available_ingredients')
      .select('ingredient_name')
      .eq('user_id', userId);

  // Extract ingredient names into a List<String>
  List<String> ingredients = [];
  for (var item in response) {
    ingredients.add(item['ingredient_name'] as String);
  }

  return ingredients;
}

Future<List<Map<String, dynamic>?>> findMatchingRecipes(String userId) async {
  // Fetch available ingredients for the user
  List<String> availableIngredients = await fetchAvailableIngredients(userId);
  print('Available Ingredients: $availableIngredients');

  final supabase = Supabase.instance.client;
  try {
    // Step 1: Call the RPC to get matching recipe IDs
    final rpcResponse =
        await supabase.rpc('find_recipes_partial_match', params: {
      'inventory_ingredients': availableIngredients,
    });

    if (rpcResponse == null) {
      throw Exception('RPC Error: ${rpcResponse}');
    }

    // Extract recipe IDs from the RPC response
    List<String> recipeIds = (rpcResponse as List<dynamic>)
        .map<String>((item) => item['recipe_id'] as String)
        .toList();
    print('Matching Recipe IDs: $recipeIds');

    if (recipeIds.isEmpty) {
      print('No matching recipes found.');
      return [];
    }

    // Step 2: Fetch detailed recipe information using the recipe IDs
    final queryResponse = await supabase.from('recipes').select('''
        id,
        title,
        description,
        difficulty,
        video_url,
        total_duration,
        serving_count,
        created_at,
        title_photo,
        nutrition(protein, carbs, fat),
        ingredients(name, quantity, unit),
        steps(description, time, step_order)
      ''').inFilter('id', recipeIds).order('created_at', ascending: false);

    // Step 3: Sort the recipes to match the order of recipeIds
    final sortedRecipes = _sortRecipesByRecipeIds(queryResponse, recipeIds);

    return sortedRecipes;
  } catch (e) {
    debugPrint('Failed to find matching recipes: $e');
    throw Exception('Failed to find matching recipes: $e');
  }
}

// Helper function to sort recipes based on the order of recipeIds
List<Map<String, dynamic>?> _sortRecipesByRecipeIds(
    List<dynamic> recipes, List<String> recipeIds) {
  // Create a map for quick lookup of recipes by their ID
  final Map<String, Map<String, dynamic>> recipeMap = {
    for (var recipe in recipes)
      recipe['id'] as String: recipe as Map<String, dynamic>
  };

  // Sort recipes in the order of recipeIds
  return recipeIds
      .map((id) => recipeMap[id])
      .where((recipe) => recipe != null)
      .toList();
}
