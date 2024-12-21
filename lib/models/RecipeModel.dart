import 'package:uuid/uuid.dart';

import '../data/constants.dart';

class Recipe {
  /// Unique recipe ID
  final String id;

  /// User ID of the recipe poster
  final String userId;

  /// Recipe name
  final String name;

  /// Total cooking/preparation duration in minutes
  int totalDuration;

  /// List of ingredients
  final List<String> ingredients;

  /// Amount for each ingredient
  final List<String> ingredientAmounts;

  /// Step-by-step instructions (also serves as description)
  final List<String> steps;

  /// Interval between steps in minutes (optional)
  final List<int> stepIntervals;

  /// URL of the title photo
  final String titlePhoto;

  /// Optional: URL of the video instruction
  final String? videoInstruction;

  Recipe({
    String? id,
    required this.userId,
    required this.name,
    this.totalDuration = 0,
    required this.ingredients,
    required this.ingredientAmounts,
    required this.steps,
    required this.stepIntervals,
    required this.titlePhoto,
    this.videoInstruction,
  }) : id = id ?? const Uuid().v4();

  /// Calculates and sets the total time of the recipe
  void calculateTotalDuration() {
    totalDuration = stepIntervals.fold(0, (sum, interval) => sum + interval);
  }

  /// Converts the Recipe to a Map (useful for Firebase or local storage)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'totalDuration': totalDuration,
      'ingredients': ingredients,
      'ingredientAmounts': ingredientAmounts,
      'steps': steps,
      'stepIntervals': stepIntervals,
      'titlePhoto': titlePhoto,
      'videoInstruction': videoInstruction,
    };
  }

  /// Creates a Recipe instance from a Map
  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'],
      userId: map['userId'],
      name: map['name'],
      totalDuration: map['totalDuration'],
      ingredients: List<String>.from(map['ingredients']),
      ingredientAmounts: List<String>.from(map['ingredientAmounts']),
      steps: List<String>.from(map['steps']),
      stepIntervals: List<int>.from(map['stepIntervals']),
      titlePhoto: map['titlePhoto'],
      videoInstruction: map['videoInstruction'],
    );
  }
}

/// Sample usage
void main() {


  recipe.calculateTotalDuration();

  print("Recipe ID: ${recipe.id}");
  print("User ID: ${recipe.userId}");
  print("Recipe Name: ${recipe.name}");
  print("Total Duration: ${recipe.totalDuration} minutes");
  print("Ingredients:");
  for (int i = 0; i < recipe.ingredients.length; i++) {
    print("- ${recipe.ingredients[i]}: ${recipe.ingredientAmounts[i]}");
  }
  print("Steps: ${recipe.steps}");
}