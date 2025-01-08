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
    Key? key,
  }) : super(key: key);

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

    await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: categoryColors[category],
          title: Text('${addOrEdit == 'EDIT' ? 'Edit' : 'Add'} $category Item'),
          content: Form(
            key: GlobalKey<FormState>(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  maxLines: 1,
                  cursorColor: Colors.black,
                  controller: TextEditingController(text: itemName),
                  decoration: InputDecoration(
                    labelText: 'Item Name',
                    labelStyle: const TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.black, width: 1),
                    ),
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
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        maxLines: 1,
                        cursorColor: Colors.black,
                        controller: TextEditingController(text: quantity.toString()),
                        decoration: InputDecoration(
                          labelText: 'Quantity',
                          labelStyle: const TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.black, width: 1),
                          ),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                        ],
                        onChanged: (value) {
                          if (RegExp(r"[a-zA-Z0-9\s\.\-\']").hasMatch(value)) {
                            quantity = double.tryParse(value) ?? quantity;
                          }
                        }
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 3,
                      child: DropdownButtonFormField<String>(
                        dropdownColor: categoryColors[category],
                        decoration: InputDecoration(
                          labelText: 'Unit',
                          labelStyle: const TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.black, width: 1),
                          ),
                        ),
                        value: selectedUnit,
                        items: Units.map((String unit) {
                          return DropdownMenuItem<String>(
                            value: unit,
                            child: Text(unit),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          if (value != null) {
                            selectedUnit = value;
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              style: TextButton.styleFrom(
                foregroundColor: Colors.black26,
              ),
              child: const Text('Cancel'),
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
              ),
              child: Text(addOrEdit == 'EDIT' ? 'Update' : 'Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: item.isPurchased ? 0.0 : 1.0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: item.isPurchased ? 0.0 : 60.0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Checkbox(
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
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item.name,
                    style: TextStyle(
                      decoration: item.isPurchased ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  Text(
                    '${item.quantity} ${item.unit}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit_outlined, size: 20),
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