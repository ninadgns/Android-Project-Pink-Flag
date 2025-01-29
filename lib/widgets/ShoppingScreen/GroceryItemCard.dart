import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/GroceryModel.dart';
import '../../services/GroceryService.dart';
import 'package:dim/data/constants.dart';

class GroceryItemCard extends StatelessWidget {
  final GroceryItem item;
  final GroceryService groceryService;
  final Function onUpdate;
  final String category;

  const GroceryItemCard({
    required this.item,
    required this.groceryService,
    required this.onUpdate,
    required this.category,
    super.key,
  });

  static void showAddItemDialog(
      BuildContext context,
      String category,
      String addOrEdit,
      GroceryService groceryService,
      Function onUpdate,
      [GroceryItem? existingItem]
      ) async {
    String itemName;
    double quantity;
    String selectedUnit;

    if (addOrEdit == 'EDIT' && existingItem != null) {
      itemName = existingItem.name;
      quantity = existingItem.quantity;
      selectedUnit = existingItem.unit;
    } else {
      itemName = '';
      quantity = 0.0;
      selectedUnit = Units[0];
    }

    final size = MediaQuery.of(context).size;
    final textScale = MediaQuery.of(context).textScaleFactor;
    final padding = size.width * 0.04;

    await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: categoryColors[category],
          title: Text(
            '${addOrEdit == 'EDIT' ? 'Edit' : 'Add'} $category Item',
            style: TextStyle(
              fontSize: textScale * 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SizedBox(
            width: size.width * 0.8,
            child: Form(
              key: GlobalKey<FormState>(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    maxLines: 1,
                    cursorColor: Colors.black,
                    controller: TextEditingController(text: itemName),
                    style: TextStyle(fontSize: textScale * 16),
                    decoration: InputDecoration(
                      labelText: 'Item Name',
                      labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: textScale * 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.black, width: 1),
                      ),
                      contentPadding: EdgeInsets.all(padding),
                    ),
                    onChanged: (value) {
                      if (RegExp(r"[a-zA-Z0-9\s\.\-\']").hasMatch(value)) {
                        itemName = value;
                      }
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z0-9\s\.\-\']")),
                    ],
                  ),
                  SizedBox(height: size.height * 0.02),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              style: TextButton.styleFrom(
                foregroundColor: Colors.black26,
                padding: EdgeInsets.all(padding),
              ),
              child: Text(
                'Cancel',
                style: TextStyle(fontSize: textScale * 14),
              ),
            ),
            TextButton(
              onPressed: () {
                if (itemName.isNotEmpty) {
                  final item = GroceryItem(
                    id: addOrEdit == 'EDIT' && existingItem != null
                        ? existingItem.id
                        : DateTime.now().millisecondsSinceEpoch.toString(),
                    name: itemName,
                    quantity: quantity,
                    unit: selectedUnit,
                    description: addOrEdit == 'EDIT' && existingItem != null
                        ? existingItem.description
                        : '',
                    category: category,
                    addedDate: addOrEdit == 'EDIT' && existingItem != null
                        ? existingItem.addedDate
                        : DateTime.now(),
                    userId: 'current_user_id',
                  );

                  if (addOrEdit == 'EDIT') {
                    groceryService.updateItem(item);
                  } else {
                    groceryService.addGroceryItem(item);
                  }

                  onUpdate();
                  Navigator.of(dialogContext).pop();
                }
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.black26,
                backgroundColor: Colors.transparent,
                padding: EdgeInsets.all(padding),
              ),
              child: Text(
                addOrEdit == 'EDIT' ? 'Update' : 'Add',
                style: TextStyle(fontSize: textScale * 14),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textScale = MediaQuery.of(context).textScaleFactor;
    final itemHeight = size.height * 0.08;
    final horizontalPadding = size.width * 0.04;
    final verticalPadding = size.height * 0.01;
    final iconSize = size.width * 0.05;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: item.isPurchased ? 0.0 : 1.0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: item.isPurchased ? 0.0 : itemHeight,
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        child: Row(
          children: [
            Transform.scale(
              scale: size.width * 0.002,
              child: Checkbox(
                value: item.isPurchased,
                onChanged: (value) {
                  if (value != null) {
                    groceryService.toggleItemStatus(item.id);
                    Future.delayed(const Duration(milliseconds: 300), () {
                      groceryService.removeItem(item.id);
                      onUpdate();
                    });
                  }
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            SizedBox(width: size.width * 0.03),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item.name,
                    style: TextStyle(
                      fontSize: textScale * 16,
                      decoration: item.isPurchased ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.edit_outlined,
                size: iconSize,
              ),
              onPressed: () => showAddItemDialog(
                  context,
                  category,
                  'EDIT',
                  groceryService,
                  onUpdate,
                  item
              ),
            ),
          ],
        ),
      ),
    );
  }
}