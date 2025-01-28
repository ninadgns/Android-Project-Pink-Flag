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

  Future<Map<String, dynamic>> generateAndSaveMealPlan() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      // Generate meal plan using RPC
      final response = await _supabase
          .rpc('generate_meal_plan', params: {'user_id_input': userId});

      // Create the meal plan entry first
      final mealPlanResult = await _supabase
          .from('meal_plans')
          .insert({
        'user_id': userId,
        'is_active': true,
        'start_date': DateTime.now().toIso8601String().split('T')[0],
        'start_day': 'Monday',
      })
          .select()
          .single();

      final String mealPlanId = mealPlanResult['id'];

      // Process and insert meals day by day
      for (int day = 1; day <= 3; day++) {
        final dayMeals = response.where((meal) =>
        meal['day_of_week'] == 'Day-$day'
        ).map((meal) => ({
          'meal_plan_id': mealPlanId,
          'day_number': day,
          'meal_type': meal['meal_type'],
          'recipe_name': meal['recipe_name'],
        })).toList();

        // Insert all meals for this day in one batch
        if (dayMeals.isNotEmpty) {
          await _supabase
              .from('meal_plan_details')
              .insert(dayMeals);
        }
      }

      // Create a simplified return structure
      Map<String, dynamic> result = {...mealPlanResult};

      // Add each day's meals to the result
      for (int day = 1; day <= 3; day++) {
        final dayMeals = response.where((meal) =>
        meal['day_of_week'] == 'Day-$day'
        ).map((meal) => ({
          'meal_type': meal['meal_type'],
          'recipe_name': meal['recipe_name'],
        })).toList();

        result['day_$day'] = dayMeals;
      }

      return result;

    } catch (e, stackTrace) {
      print('Error details: $e');
      print('Stack trace: $stackTrace');
      throw Exception('Failed to generate and save meal plan: $e');
    }
  }

  Future<void> updateDayMeals({
    required String mealPlanId,
    required int dayNumber,
    required List<Map<String, String>> meals,
  }) async {
    try {
      if (dayNumber > 3) {
        throw Exception('Cannot update meals beyond day 3');
      }

      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      // Delete existing meals for this day
      await _supabase
          .from('meal_plan_details')
          .delete()
          .eq('meal_plan_id', mealPlanId)
          .eq('day_number', dayNumber);

      // Insert all new meals for this day in one batch
      final mealDetails = meals.map((meal) => ({
        'meal_plan_id': mealPlanId,
        'day_number': dayNumber,
        'meal_type': meal['meal_type'],
        'recipe_name': meal['recipe_name'],
      })).toList();

      await _supabase
          .from('meal_plan_details')
          .insert(mealDetails);

    } catch (e) {
      throw Exception('Failed to update day meals: $e');
    }
  }
}