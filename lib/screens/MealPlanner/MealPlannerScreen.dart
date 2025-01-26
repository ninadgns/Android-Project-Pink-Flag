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

  @override
  void initState() {
    super.initState();
    _loadMealPlan();
  }

  Future<void> _loadMealPlan() async {
    try {
      setState(() => _isLoading = true);
      final response = await _mealPlanService.generateMealPlan();

      final mealsByDay = <String, List<MealPlan>>{};
      for (final meal in response) {
        final mealPlan = MealPlan.fromJson(meal);
        mealsByDay.putIfAbsent(mealPlan.dayOfWeek, () => []).add(mealPlan);
      }

      setState(() {
        _mealPlan = mealsByDay.entries
            .map((e) => DayMeals(day: e.key, meals: e.value))
            .toList();
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
              // Show recipe selection dialog
              // Update meal plan using service
            },
          )),
        ],
      ),
    );
  }
}