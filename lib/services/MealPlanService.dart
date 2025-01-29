import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/MealPlanModels.dart';

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

      // Generate meal plan using RPC
      final List<Map<String, dynamic>> response = await _supabase
          .rpc('generate_meal_plan', params: {'user_id_input': userId});

      print(response);

      return response;
    } catch (e, stackTrace) {
      print('Error details: $e');
      print('Stack trace: $stackTrace');
      // Try to clean up on error
      try {
        await _supabase.rpc('cleanup_meal_plan_temps');
      } catch (cleanupError) {
        print('Cleanup error: $cleanupError');
      }

      throw Exception('Failed to generate and save meal plan: $e');
    }
  }


  Future<Map<String, dynamic>> storeMealPlan(List<Map<String, dynamic>> response) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      // Create the meal plan entry
      final mealPlanInsert = await _supabase
          .from('meal_plans')
          .insert({
        'user_id': userId,
        'is_active': true,
        'start_date': DateTime.now().toIso8601String(),
        'start_day': 'Monday',
      })
          .select()
          .single();
      print(mealPlanInsert);

      final String mealPlanId = mealPlanInsert['id'] as String;
      print(mealPlanId);
      // Process and insert meals day by day
      for (int day = 1; day <= 7; day++) {
        final dayMeals = response
            .where((meal) => meal['day_of_week'] == 'Day-$day')
            .map((meal) => {
          'meal_plan_id': mealPlanId,
          'day_number': day,
          'meal_type': meal['meal_type'],
          'recipe_name': meal['recipe_name'],
        })
            .toList();

        // Insert all meals for this day in one batch
        if (dayMeals.isNotEmpty) {
          await _supabase
              .from('meal_plan_details')
              .insert(dayMeals);
        }
      }

      // Create a simplified return structure
      Map<String, dynamic> result = {'id': mealPlanId};
      print(result);
      // Add each day's meals to the result
      for (int day = 1; day <= 7; day++) {
        final dayMeals = response
            .where((meal) => meal['day_of_week'] == 'Day-$day')
            .map((meal) => {
          'meal_type': meal['meal_type'],
          'recipe_name': meal['recipe_name'],
        })
            .toList();

        result['day_$day'] = dayMeals;
      }

      return result;
    } catch (e) {
      throw Exception('Failed to store meal plan: $e');
    }
  }

  Future<List<DayMeals>> fetchCurrentMealPlan(String mealPlanId) async {
    try {
      // Fetch the meal plan to get start date
      final mealPlan = await _supabase
          .from('meal_plans')
          .select()
          .eq('id', mealPlanId)
          .single();

      final DateTime startDate = DateTime.parse(mealPlan['start_date']);

      // Fetch all meal details for this plan
      final List<Map<String, dynamic>> mealDetails = await _supabase
          .from('meal_plan_details')
          .select()
          .eq('meal_plan_id', mealPlanId)
          .order('day_number');

      // Create a map to store meals by day
      final Map<int, List<MealPlan>> mealsByDay = {};

      // Define meal type order for sorting
      const mealTypeOrder = {
        'Breakfast': 1,
        'Lunch': 2,
        'Dinner': 3,
      };

      // Process each meal
      for (var meal in mealDetails) {
        final int dayNumber = meal['day_number'];
        mealsByDay.putIfAbsent(dayNumber, () => []);

        // Calculate the actual date for this meal
        final DateTime mealDate = startDate.add(Duration(days: dayNumber - 1));
        final String formattedDate = '${mealDate.day}/${mealDate.month}/${mealDate.year}';

        mealsByDay[dayNumber]!.add(MealPlan(
          dayOfWeek: formattedDate,
          mealType: meal['meal_type'],
          recipeName: meal['recipe_name'],
          recipeId: '',
        ));
      }

      // Sort meals within each day by meal type order
      for (var dayMeals in mealsByDay.values) {
        dayMeals.sort((a, b) =>
            (mealTypeOrder[a.mealType] ?? 0).compareTo(mealTypeOrder[b.mealType] ?? 0)
        );
      }

      // Convert map entries to a sorted list by day number
      final sortedEntries = mealsByDay.entries.toList()
        ..sort((a, b) => a.key.compareTo(b.key));

      // Create the final sorted list of DayMeals
      return sortedEntries.map((entry) => DayMeals(
        day: entry.value.first.dayOfWeek,
        meals: entry.value,
      )).toList();

    } catch (e) {
      print('Error fetching meal plan: $e');
      throw Exception('Failed to fetch meal plan: $e');
    }
  }

  // Check for active meal plan
  Future<String?> getActiveMealPlanId() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      final activeMealPlan = await _supabase
          .from('meal_plans')
          .select('id')
          .eq('user_id', userId)
          .eq('is_active', true)
          .maybeSingle();  // Use maybeSingle() since user might not have an active plan

      return activeMealPlan?['id'] as String?;
    } catch (e) {
      print('Error checking active meal plan: $e');
      throw Exception('Failed to check active meal plan: $e');
    }
  }

// Deactivate all active meal plans for the user
  Future<void> deactivateCurrentMealPlans() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      // Update all active meal plans to inactive
      await _supabase
          .from('meal_plans')
          .update({'is_active': false})
          .eq('user_id', userId)
          .eq('is_active', true);
    } catch (e) {
      print('Error deactivating meal plans: $e');
      throw Exception('Failed to deactivate meal plans: $e');
    }
  }

}