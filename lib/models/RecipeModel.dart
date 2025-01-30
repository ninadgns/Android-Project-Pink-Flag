import 'package:uuid/uuid.dart';

class Nutrition {
  final int fat;
  final int carbs;
  final int protein;

  Nutrition({
    required this.fat,
    required this.carbs,
    required this.protein,
  });

  factory Nutrition.fromMap(Map<String, dynamic> map) {
    return Nutrition(
      fat: map['fat'],
      carbs: map['carbs'],
      protein: map['protein'],
    );
  }
  int energy() {
    return fat * 9 + carbs * 4 + protein * 4;
  }

  Map<String, dynamic> toMap() {
    return {
      'fat': fat,
      'carbs': carbs,
      'protein': protein,
    };
  }
}

class Ingredient {
  final String name;
  final String unit;
  final double quantity;

  Ingredient({
    required this.name,
    required this.unit,
    required this.quantity,
  });

  factory Ingredient.fromMap(Map<String, dynamic> map) {
    return Ingredient(
      name: map['name'],
      unit: map['unit'],
      quantity: map['quantity'].toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'unit': unit,
      'quantity': quantity,
    };
  }
}

class Step {
  final int time;
  final int stepOrder;
  final String description;

  Step({
    required this.time,
    required this.stepOrder,
    required this.description,
  });

  factory Step.fromMap(Map<String, dynamic> map) {
    return Step(
      time: map['time'],
      stepOrder: map['step_order'],
      description: map['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'time': time,
      'step_order': stepOrder,
      'description': description,
    };
  }
}

class Recipe {
  final String id;
  final String userId;
  final String name;
  final String description;
  int totalDuration;
  final Nutrition nutrition;
  final List<Ingredient> ingredients;
  final List<Step> steps;
  final int servings;
  final String difficulty;
  final String titlePhoto;
  final String? videoInstruction;
  int loveCount;

  Recipe({
    String? id,
    required this.userId,
    required this.name,
    required this.description,
    this.totalDuration = 0,
    required this.nutrition,
    required this.ingredients,
    required this.steps,
    required this.servings,
    required this.difficulty,
    required this.titlePhoto,
    this.loveCount = 0,
    this.videoInstruction,
  }) : id = id ?? const Uuid().v4() {
    steps.sort((a, b) => a.stepOrder.compareTo(b.stepOrder));
  }

  factory Recipe.fromMap(Map<String, dynamic> map) {
    final recipe = Recipe(
      id: map['id'] ?? '',
      userId: map['user_id'] ?? '',
      name: map['title'] ?? '',
      description: map['description'] ?? '',
      totalDuration: map['totalDuration'] ?? 0,
      nutrition: Nutrition.fromMap((map['nutrition'] as List).first ?? {}),
      ingredients: List<Ingredient>.from(
          (map['ingredients'] ?? []).map((x) => Ingredient.fromMap(x))),
      steps: List<Step>.from((map['steps'] ?? []).map((x) => Step.fromMap(x))),
      servings: map['serving_count'] ?? 0,
      difficulty: map['difficulty'] ?? '',
      titlePhoto: map['title_photo'] ?? '',
      videoInstruction: map['videoInstruction'] ?? '',
    );
    // print(recipe.titlePhoto);
    return recipe;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'description': description,
      'totalDuration': totalDuration,
      'nutrition': nutrition.toMap(),
      'ingredients': ingredients.map((x) => x.toMap()).toList(),
      'steps': steps.map((x) => x.toMap()).toList(),
      'servings': servings,
      'difficulty': difficulty,
      'title_photo': titlePhoto,
      'videoInstruction': videoInstruction,
    };
  }

  void calculateTotalDuration() {
    totalDuration = steps.fold(0, (sum, step) => sum + step.time);
  }
}

List<Recipe> parseRecipes(List<Map<String, dynamic>?> response) {
  return response.map((recipeMap) => Recipe.fromMap(recipeMap!)).toList();
}
