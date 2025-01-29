import 'dart:math';

import 'package:flutter/material.dart';
import '../../models/GroceryModel.dart';
import '../../services/GroceryService.dart';
import 'GroceryItemCard.dart';

class CategorySection extends StatelessWidget {
  final String category;
  final Color backgroundColor;
  final GroceryService groceryService;
  final Function onAddItem;
  final Function onUpdate;

  const CategorySection({
    required this.category,
    required this.backgroundColor,
    required this.groceryService,
    required this.onAddItem,
    required this.onUpdate,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<GroceryItem>>(
      future: groceryService.getGroceryListByCategory(category),
      builder: (BuildContext context, AsyncSnapshot<List<GroceryItem>> snapshot) {
        final items = snapshot.data ?? [];
        final screenHeight = MediaQuery.of(context).size.height;

        // Make category heights responsive to screen size
        final double minCategoryHeight = screenHeight * 0.1; // 10% of screen height
        final double itemHeight = screenHeight * 0.08; // 8% of screen height

        final double categoryHeight = items.isEmpty
            ? minCategoryHeight
            : min(screenHeight * 0.4, // Maximum 40% of screen height
            minCategoryHeight + (items.length * itemHeight));

        return ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: minCategoryHeight,
            maxHeight: screenHeight * 0.4, // Maximum 40% of screen height
          ),
          child: Container(
            height: categoryHeight,
            margin: EdgeInsets.symmetric(
              vertical: screenHeight * 0.01, // 1% of screen height
              horizontal: MediaQuery.of(context).size.width * 0.04, // 4% of screen width
            ),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.all(screenHeight * 0.02), // 2% of screen height
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        category,
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.045, // 4.5% of screen width
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.add_circle_outline,
                          size: MediaQuery.of(context).size.width * 0.06, // 6% of screen width
                        ),
                        onPressed: () => GroceryItemCard.showAddItemDialog(
                            context,
                            category,
                            'ADD',
                            groceryService,
                            onUpdate,
                            null
                        ),
                      ),
                    ],
                  ),
                ),
                if (items.isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: items.length,
                      itemBuilder: (context, index) => GroceryItemCard(
                        item: items[index],
                        groceryService: groceryService,
                        onUpdate: onUpdate,
                        category: category,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}