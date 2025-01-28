class Ingredient {
  final int id;
  final String name;
  final String categoryId;

  Ingredient({
    required this.id,
    required this.name,
    required this.categoryId,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      id: json['ingredient_id'],
      name: json['name'],
      categoryId: json['category_id'],
    );
  }
}
