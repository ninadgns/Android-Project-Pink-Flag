import 'package:uuid/uuid.dart';


class Recipe {
  /// Unique recipe ID
  final String id;

  /// User ID of the recipe poster
  final String userId;

  /// Recipe name
  final String name;

  /// Short description
  final String description;

  /// Total cooking/preparation duration in minutes
  int totalDuration;

  int energy;
  int protein;
  int carbs;
  int fat;

  /// Difficulty level
  final String difficulty;

  /// List of ingredients
  final List<String> ingredients;

  /// Amount for each ingredient
  final List<String> ingredientAmounts;

  /// The unit of measurement for each ingredient
  final List<String> ingredientUnits;

  /// Number of servings
  final int servings;

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
    required this.description,
    this.totalDuration = 0,
    this.energy = 0,
    this.protein = 0,
    this.carbs = 0,
    this.fat = 0,
    required this.servings,
    required this.difficulty,
    required this.ingredients,
    required this.ingredientAmounts,
    required this.ingredientUnits,
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
      'description': description,
      'totalDuration': totalDuration,
      'difficulty': difficulty.toString().split('.').last,
      'ingredients': ingredients,
      'energy': energy,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'servings': servings,
      'ingredientAmounts': ingredientAmounts,
      'ingredientUnits': ingredientUnits,
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
      description: map['description'],
      totalDuration: map['totalDuration'],
      difficulty: map['difficulty'],
      energy: map['energy'],
      protein: map['protein'],
      carbs: map['carbs'],
      fat: map['fat'],
      servings: map['servings'],
      ingredients: List<String>.from(map['ingredients']),
      ingredientAmounts: List<String>.from(map['ingredientAmounts']),
      ingredientUnits: List<String>.from(map['ingredientUnits']),
      steps: List<String>.from(map['steps']),
      stepIntervals: List<int>.from(map['stepIntervals']),
      titlePhoto: map['titlePhoto'],
      videoInstruction: map['videoInstruction'],
    );
  }
}