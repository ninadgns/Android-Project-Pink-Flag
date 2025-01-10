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
        const double minCategoryHeight = 80.0;
        const double itemHeight = 60.0;

        final double categoryHeight = items.isEmpty
            ? minCategoryHeight
            : minCategoryHeight + (items.length * itemHeight);

        return Container(
          height: categoryHeight,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      category,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
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
        );
      },
    );
  }
}