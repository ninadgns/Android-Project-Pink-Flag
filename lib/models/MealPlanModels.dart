import 'package:flutter/material.dart';



class MealPlan {
  final String id;
  final DateTime date;
  final List<DailyMeal> meals;
  final double totalCalories;
  final Map<String, double> macros; // proteins, carbs, fats
  final String userId;
  final bool isCompleted;

  MealPlan({
    required this.id,
    required this.date,
    required this.meals,
    required this.totalCalories,
    required this.macros,
    required this.userId,
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date.toIso8601String(),
    'meals': meals.map((meal) => meal.toJson()).toList(),
    'totalCalories': totalCalories,
    'macros': macros,
    'userId': userId,
    'isCompleted': isCompleted,
  };

  factory MealPlan.fromJson(Map<String, dynamic> json) {
    return MealPlan(
      id: json['id'],
      date: DateTime.parse(json['date']),
      meals: (json['meals'] as List).map((meal) => DailyMeal.fromJson(meal)).toList(),
      totalCalories: json['totalCalories'],
      macros: Map<String, double>.from(json['macros']),
      userId: json['userId'],
      isCompleted: json['isCompleted'] ?? false,
    );
  }

}


class DailyMeal {
  final String id;
  final String name;
  final MealType type;
  final DateTime time;
  final double calories;
  final Map<String, double> macros;
  bool isCompleted;

  DailyMeal({
    required this.id,
    required this.name,
    required this.type,
    required this.time,
    required this.calories,
    required this.macros,
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'type': type.toString(),
    'time': time.toIso8601String(),
    'calories': calories,
    'macros': macros,
    'isCompleted': isCompleted,
  };

  factory DailyMeal.fromJson(Map<String, dynamic> json) {
    return DailyMeal(
      id: json['id'],
      name: json['name'],
      type: MealType.values.firstWhere(
            (e) => e.toString() == json['type'],
      ),
      time: DateTime.parse(json['time']),
      calories: json['calories'],
      macros: Map<String, double>.from(json['macros']),
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}

enum MealType { breakfast, lunch, dinner, snack, brunch, dessert }




