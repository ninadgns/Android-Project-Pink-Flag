import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/MealPlanModels.dart';
import '../../services/MealPlanService.dart';
import '../../widgets/MealPlan/RecipeItem.dart';

class MealPlanScreen extends StatefulWidget {
  const MealPlanScreen({super.key});

  @override
  State<MealPlanScreen> createState() => _MealPlanScreenState();
}

class _MealPlanScreenState extends State<MealPlanScreen> {
  final _mealPlanService = MealPlanService(supabase: Supabase.instance.client);
  List<DayMeals> _mealPlan = [];
  bool _isLoading = true;
  String? _currentMealPlanId;

  @override
  void initState() {
    super.initState();
    _loadMealPlan();
  }

  Future<void> _loadMealPlan() async {
    try {
      setState(() => _isLoading = true);
      final response = await _mealPlanService.generateAndSaveMealPlan();

      _currentMealPlanId = response['id'];
      final List<DayMeals> dayMealsList = [];

      // Process each day's meals from day_1 to day_7
      for (int i = 1; i <= 7; i++) {
        final dayKey = 'day_$i';
        if (response[dayKey] != null) {
          final List<dynamic> dayMeals = response[dayKey];
          final meals = dayMeals.map((meal) => MealPlan(
            dayOfWeek: 'Day-$i',
            mealType: meal['meal_type'],
            recipeName: meal['recipe_name'],
            recipeId: '', // Since we're not storing recipe_id in the new format
          )).toList();

          dayMealsList.add(DayMeals(
            day: 'Day-$i',
            meals: meals,
          ));
        }
      }

      setState(() {
        _mealPlan = dayMealsList;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading meal plan: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateDayMeal(String day, String mealType, String newRecipeName) async {
    try {
      if (_currentMealPlanId == null) return;

      final dayNumber = int.parse(day.split('-')[1]);
      final currentDayMeals = _mealPlan
          .firstWhere((dm) => dm.day == day)
          .meals
          .map((m) => {
        'meal_type': m.mealType,
        'recipe_name': m.mealType == mealType ? newRecipeName : m.recipeName,
      })
          .toList();

      await _mealPlanService.updateDayMeals(
        mealPlanId: _currentMealPlanId!,
        dayNumber: dayNumber,
        meals: currentDayMeals,
      );

      // Refresh the meal plan after updating
      _loadMealPlan();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating meal: $e')),
        );
      }
    }
  }

  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Meal Plan'),
          backgroundColor: const Color(0xFF9FC9C8),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadMealPlan,
            ),
          ],
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
          onRefresh: _loadMealPlan,
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  itemCount: _mealPlan.length,
                  itemBuilder: (context, index) {
                    final dayMeals = _mealPlan[index];
                    return _buildDayCard(dayMeals);
                  },
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDayCard(DayMeals dayMeals) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              dayMeals.day,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF8CB5B5),
              ),
            ),
          ),
          const Divider(height: 1),
          ...dayMeals.meals.map((meal) => RecipeItem(
            recipeName: meal.recipeName,
            mealType: meal.mealType,
            onEdit: () async {
              // Here you would implement your recipe selection dialog
              // For example:
              // final newRecipe = await showRecipeSelectionDialog(context);
              // if (newRecipe != null) {
              //   await _updateDayMeal(dayMeals.day, meal.mealType, newRecipe);
              // }
            },
          )),
        ],
      ),
    );
  }
}