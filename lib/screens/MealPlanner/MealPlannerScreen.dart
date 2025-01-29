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

      if(mealPlanId == null) {
        final List<Map<String, dynamic>> response = await _mealPlanService
            .generateMealPlan();
        final storedPlan = await _mealPlanService.storeMealPlan(response);
        mealPlanId = storedPlan['id'];
      }

      // Get the meal plan details with dates from Supabase
      final List<DayMeals> dayMealsList = await _mealPlanService.fetchCurrentMealPlan(mealPlanId!);

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
    } catch(e) {
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

  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Theme(
      data: Theme.of(context).copyWith(
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(screenSize.width * 0.032)
          ),
          margin: EdgeInsets.symmetric(
              horizontal: screenSize.width * 0.043,
              vertical: screenSize.height * 0.01
          ),
        ),
      ),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(screenSize.height * 0.08),
          child: AppBar(
            title: Row(
              children: [
                Text(
                  'Meal Plan',
                  style: TextStyle(
                      fontSize: screenSize.width * 0.065
                  ),
                ),
                SizedBox(width: screenSize.width * 0.06), // Add some spacing
                Text(
                  _getCurrentDate(), // Custom method to get today's date
                  style: TextStyle(
                      fontSize: screenSize.width * 0.045,
                      fontWeight: FontWeight.w300
                  ),
                ),
              ],
            ),
            backgroundColor: const Color(0xFF9FC9C8),
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: Icon(
                    Icons.next_plan_outlined,
                    size: screenSize.width * 0.07
                ),
                onPressed: _giveNewPlan,
                padding: EdgeInsets.all(screenSize.width * 0.03),
              ),
            ],
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
          onRefresh: _loadMealPlan,
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(
                      vertical: screenSize.height * 0.02
                  ),
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
                color: const Color(0xFF8CB5B5),
              ),
            ),
          ),
          Divider(
            height: 1,
            thickness: screenSize.height * 0.001,
          ),
          Column(
            children: dayMeals.meals.map((meal) => Padding(
              padding: EdgeInsets.symmetric(
                vertical: screenSize.height * 0.004,
              ),
              child: RecipeItem(
                recipeName: meal.recipeName,
                mealType: meal.mealType,
                onEdit: () async {
                },
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }
}