import 'package:flutter/material.dart';


class GroceryItem {
  final String id;
  final String name;
  final double quantity;
  final String unit;
  final String category;
  bool isPurchased;
  final DateTime addedDate;
  final String userId;

  GroceryItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.unit,
    required this.category,
    this.isPurchased = false,
    required this.addedDate,
    required this.userId,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'quantity': quantity,
    'unit': unit,
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
      category: json['category'],
      isPurchased: json['isPurchased'],
      addedDate: DateTime.parse(json['addedDate']),
      userId: json['userId'],
    );
  }
}