import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<List<Map<String, dynamic>>> fetchRecipes() async {
  final supabase = Supabase.instance.client;

  try {
    // Fetch all recipes with their related ingredients and steps
    final response = await supabase.from('recipes').select('''
          id,
          title,
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
    // debugPrint('Recipes: $response');
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
          description,
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
    // Step 1: Fetch recipe IDs associated with the given tag

    final tagResponse =
        await supabase.from('tags').select('recipe_id').eq('tag', tag);
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
