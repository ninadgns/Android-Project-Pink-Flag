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
    final screenSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: screenSize.width * 0.04,
          vertical: screenSize.height * 0.01
      ),
      child: Row(
        children: [
          _getIcon(),
          SizedBox(width: screenSize.width * 0.04),
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
                SizedBox(height: screenSize.height * 0.005),
                Text(
                  recipeName,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
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