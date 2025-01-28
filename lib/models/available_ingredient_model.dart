class AvailableIngredient {
  final int? id;
  final String userId;
  final int? ingredientId; // Null if not found
  final String ingredientName;
  final DateTime createdAt;

  AvailableIngredient({
    this.id,
    required this.userId,
    this.ingredientId,
    required this.ingredientName,
    required this.createdAt,
  });

  factory AvailableIngredient.fromJson(Map<String, dynamic> json) {
    return AvailableIngredient(
      id: json['id'],
      userId: json['user_id'],
      ingredientId: json['ingredient_id'],
      ingredientName: json['ingredient_name'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
  