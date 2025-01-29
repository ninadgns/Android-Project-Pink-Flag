import 'package:dim/screens/Profile/PreferencesScreen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

      String? mealPlanId = await _mealPlanService.getActiveMealPlanId();

      if (mealPlanId == null) {
        final List<Map<String, dynamic>> response =
            await _mealPlanService.generateMealPlan();
        final storedPlan = await _mealPlanService.storeMealPlan(response);
        mealPlanId = storedPlan['id'];
      }

      // Get the meal plan details with dates from Supabase
      final List<DayMeals> dayMealsList =
          await _mealPlanService.fetchCurrentMealPlan(mealPlanId!);

      setState(() {
        _mealPlan = dayMealsList;
        _currentMealPlanId = mealPlanId;
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

  Future<void> _giveNewPlan() async {
    try {
      await _mealPlanService.deactivateCurrentMealPlans();
      return _loadMealPlan();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading meal plan: $e')),
        );
      }
    }
  }

  String _getCurrentDate() {
    final now = DateTime.now();
    final DateFormat formatter = DateFormat('d MMMM'); // Day and Month name
    return formatter.format(now);
  }

  void _navigateToNextScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            const PreferencesScreen(), // Replace with your screen
      ),
    );
  }

  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Theme(
      data: Theme.of(context).copyWith(
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(screenSize.width * 0.032)),
          margin: EdgeInsets.symmetric(
              horizontal: screenSize.width * 0.043,
              vertical: screenSize.height * 0.01),
        ),
      ),
      child: Scaffold(
          body: Column(children: [
        // Custom Header
        Container(
          padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.02,
            horizontal: MediaQuery.of(context).size.width * 0.05,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Back Button

              // Centered Title
              Text(
                'Meal Plan',
                style: Theme.of(context).textTheme.displayMedium,
              ),

              // Next Plan Button
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.black),
                onPressed: _giveNewPlan,
              ),
            ],
          ),
        ),

        // Scrollable Meal Plan Content
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: _loadMealPlan,
                  child: Column(
                    children: [
                      SizedBox(
                        width: screenSize.width * 0.6,
                        height: screenSize.height * 0.06,
                        child: ElevatedButton(
                          onPressed: _navigateToNextScreen,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8CB5B5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  screenSize.width * 0.02),
                            ),
                          ),
                          child: Text(
                            'My Preferences',
                            style: TextStyle(
                              fontSize: screenSize.width * 0.04,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.symmetric(
                              vertical: screenSize.height * 0.02),
                          itemCount: _mealPlan.length,
                          itemBuilder: (context, index) {
                            final dayMeals = _mealPlan[index];
                            return _buildDayCard(dayMeals, context);
                          },
                        ),
                      ),
                      SizedBox(height: screenSize.height * 0.1),
                    ],
                  ),
                ),
        ),
      ])),
    );
  }

  Widget _buildDayCard(DayMeals dayMeals, BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(screenSize.width * 0.043),
            child: Text(
              dayMeals.day,
              style: TextStyle(
                fontSize: screenSize.width * 0.053,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Divider(
            height: 1,
            thickness: screenSize.height * 0.001,
          ),
          Column(
            children: dayMeals.meals
                .map((meal) => Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: screenSize.height * 0.004,
                      ),
                      child: RecipeItem(
                        recipeName: meal.recipeName,
                        mealType: meal.mealType,
                        onEdit: () async {},
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
