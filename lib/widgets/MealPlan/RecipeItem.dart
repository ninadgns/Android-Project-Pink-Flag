import 'package:flutter/material.dart';

class RecipeItem extends StatelessWidget {
  final String recipeName;
  final String mealType;
  final VoidCallback? onEdit;

  const RecipeItem({
    required this.recipeName,
    required this.mealType,
    this.onEdit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _getIcon(),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mealType,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  recipeName,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          // if (onEdit != null)
          //   IconButton(
          //     icon: const Icon(Icons.edit, color: Colors.grey),
          //     onPressed: onEdit,
          //   ),
        ],
      ),
    );
  }

  Widget _getIcon() {
    IconData iconData;
    Color iconColor;
    switch (mealType.toLowerCase()) {
      case 'breakfast':
        iconData = Icons.free_breakfast;
        iconColor = Colors.lightGreen.shade600;
        break;
      case 'lunch':
        iconData = Icons.lunch_dining;
        iconColor = Colors.orangeAccent;
        break;
      case 'dinner':
        iconData = Icons.dinner_dining;
        iconColor = Colors.indigo;
        break;
      default:
        iconData = Icons.restaurant;
        iconColor = Colors.grey;
    }
    return Icon(iconData, color: iconColor, size: 24);
  }
}