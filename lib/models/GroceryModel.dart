

class GroceryItem {
  final String id;
  final String name;
  final double quantity;
  final String unit;
  final String description;
  final String category;
  final String? icon;
  bool isPurchased;
  final DateTime addedDate;
  final String userId;

  GroceryItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.unit,
    required this.description,
    required this.category,
    this.icon,
    this.isPurchased = false,
    required this.addedDate,
    required this.userId,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'quantity': quantity,
    'unit': unit,
    'description': description,
    'category': category,
    'isPurchased': isPurchased,
    'addedDate': addedDate.toIso8601String(),
    'userId': userId,
  };

  factory GroceryItem.fromJson(Map<String, dynamic> json) {
    return GroceryItem(
      id: json['id'],
      name: json['name'],
      quantity: json['quantity'],
      unit: json['unit'],
      description: json['description'],
      category: json['category'],
      isPurchased: json['isPurchased'],
      addedDate: DateTime.parse(json['addedDate']),
      userId: json['userId'],
    );
  }
}