import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';

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
          image_url,
          nutrition(protein, carbs, fat),
          ingredients(name, quantity, unit),
          steps(description, time, step_order)
        ''').order('created_at', ascending: false);

    if (response.isEmpty) {
      debugPrint('No recipes found.');
      return [];
    }

    debugPrint('Recipes fetched successfully.');
    debugPrint('Recipes: $response');
    return List<Map<String, dynamic>>.from(response);
  } catch (e) {
    debugPrint('Failed to fetch recipes: $e');
    throw Exception('Failed to fetch recipes');
  }
}
