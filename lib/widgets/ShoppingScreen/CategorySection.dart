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
        final size = MediaQuery.of(context).size;
        final textScale = MediaQuery.of(context).textScaleFactor;

        // Dynamic sizes based on screen dimensions
        final double minCategoryHeight = size.height * 0.1;  // 10% of screen height
        final double itemHeight = size.height * 0.08;        // 8% of screen height
        final double maxCategoryHeight = size.height * 0.4;  // 40% of screen height
        final double horizontalPadding = size.width * 0.04;  // 4% of screen width
        final double verticalPadding = size.height * 0.01;   // 1% of screen height
        final double iconSize = size.width * 0.06;           // 6% of screen width
        final double titleSize = size.width * 0.045;         // 4.5% of screen width

        final double categoryHeight = items.isEmpty
            ? minCategoryHeight
            : min(maxCategoryHeight, minCategoryHeight + (items.length * itemHeight));

        return LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              height: categoryHeight,
              margin: EdgeInsets.symmetric(
                vertical: verticalPadding,
                horizontal: horizontalPadding,
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
                    padding: EdgeInsets.all(size.width * 0.04),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          category,
                          style: TextStyle(
                            fontSize: titleSize * textScale,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.add_circle_outline,
                            size: iconSize,
                          ),
                          onPressed: () => GroceryItemCard.showAddItemDialog(
                            context,
                            category,
                            'ADD',
                            groceryService,
                            onUpdate,
                            null,
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
            );
          },
        );
      },
    );
  }
}