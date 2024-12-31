import 'package:flutter/material.dart';


class NutritionData {
  final String id;
  final DateTime date;
  final double targetCalories;
  final Map<String, double> targetMacros;
  final double consumedCalories;
  final Map<String, double> consumedMacros;
  final String userId;

  NutritionData({
    required this.id,
    required this.date,
    required this.targetCalories,
    required this.targetMacros,
    required this.consumedCalories,
    required this.consumedMacros,
    required this.userId,
  });

  double get remainingCalories => targetCalories - consumedCalories;

  Map<String, double> get remainingMacros {
    return targetMacros.map((key, value) =>
        MapEntry(key, value - (consumedMacros[key] ?? 0)));
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date.toIso8601String(),
    'targetCalories': targetCalories,
    'targetMacros': targetMacros,
    'consumedCalories': consumedCalories,
    'consumedMacros': consumedMacros,
    'userId': userId,
  };

  factory NutritionData.fromJson(Map<String, dynamic> json) {
    return NutritionData(
      id: json['id'],
      date: DateTime.parse(json['date']),
      targetCalories: json['targetCalories'],
      targetMacros: Map<String, double>.from(json['targetMacros']),
      consumedCalories: json['consumedCalories'],
      consumedMacros: Map<String, double>.from(json['consumedMacros']),
      userId: json['userId'],
    );
  }
}