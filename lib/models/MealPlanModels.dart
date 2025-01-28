class MealPlan {
  final String dayOfWeek;
  final String mealType;
  final String recipeId;
  final String recipeName;

  MealPlan({
    required this.dayOfWeek,
    required this.mealType,
    required this.recipeId,
    required this.recipeName,
  });

  factory MealPlan.fromJson(Map<String, dynamic> json) {
    return MealPlan(
      dayOfWeek: json['day_of_week'],
      mealType: json['meal_type'],
      recipeId: json['recipe_id'],
      recipeName: json['recipe_name'],
    );
  }
}

class DayMeals {
  final String day;
  final List<MealPlan> meals;

  DayMeals({required this.day, required this.meals});
}