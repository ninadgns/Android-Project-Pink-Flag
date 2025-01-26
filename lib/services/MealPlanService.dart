import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MealPlanService {
  final SupabaseClient _supabase;
  final FirebaseAuth _auth;

  MealPlanService({
    required SupabaseClient supabase,
    FirebaseAuth? auth,
  }) : _supabase = supabase,
        _auth = auth ?? FirebaseAuth.instance;

  Future<List<Map<String, dynamic>>> generateMealPlan() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      final response = await _supabase
          .rpc('generate_meal_plan', params: {'user_id_input': userId});

      print(response);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to generate meal plan: $e');
    }
  }

  Future<void> updateMealPlan({
    required String dayOfWeek,
    required String mealType,
    required String recipeId,
  }) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      // Add your update logic here
      // You might want to store the meal plan in a separate table
    } catch (e) {
      throw Exception('Failed to update meal plan: $e');
    }
  }
}