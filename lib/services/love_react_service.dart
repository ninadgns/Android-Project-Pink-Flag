import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class LoveReactService {
  final supabase = Supabase.instance.client;
  final uuid = Uuid();

  /// Fetch all users who reacted to a recipe
  Future<List<Map<String, dynamic>>> fetchLoveReacts(String recipeId) async {
    final response = await supabase
        .from('recipe_loves')
        .select('*')
        .eq('recipe_id', recipeId);

    return response;
  }

  /// Check if the current user has reacted
  Future<bool> hasUserLoved(String recipeId, String userId) async {
    final response = await supabase
        .from('recipe_loves')
        .select('id')
        .eq('recipe_id', recipeId)
        .eq('user_id', userId)
        .maybeSingle();

    return response != null;
  }

  /// Add a love reaction
  Future<void> addLoveReact(String recipeId, String userId, String userName) async {
    await supabase.from('recipe_loves').insert({
      'id': uuid.v4(), // Generates a unique ID
      'recipe_id': recipeId,
      'user_id': userId,

    });
  }

  /// Remove a love reaction
  Future<void> removeLoveReact(String recipeId, String userId) async {
    await supabase
        .from('recipe_loves')
        .delete()
        .eq('recipe_id', recipeId)
        .eq('user_id', userId);
  }
}
