import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/GroceryModel.dart';

class GroceryService {
  // this would be a database or API call
  static final List<GroceryItem> _groceryItems = [];

  Future<List<GroceryItem>> getGroceryListByCategory(String category) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _groceryItems
        .where((item) => item.category.toLowerCase() == category.toLowerCase())
        .toList();
  }

  Future<void> addGroceryItem(GroceryItem item) async {
    _groceryItems.add(item);
    try {
      await Supabase.instance.client.from('shopping_list').insert({
        'id': item.id,
        'name': item.name,
        'category': item.category,
        'user_id': item.userId,
      });
    } catch (e) {
      print("Failed to add item to shopping list: $e");
    }
    print("Added item to shopping list");
  }

  Future<void> removeItem(String itemId) async {
    _groceryItems.removeWhere((item) => item.id == itemId);
    try {
      await Supabase.instance.client
          .from('shopping_list')
          .delete()
          .eq('id', itemId);
    } catch (e) {
      print("Failed to remove item from shopping list: $e");
    }
  }

  Future<void> updateItem(GroceryItem updatedItem) async {
    final index = _groceryItems.indexWhere((item) => item.id == updatedItem.id);
    if (index != -1) {
      _groceryItems[index] = updatedItem;
      print(updatedItem);
      try {
        await Supabase.instance.client.from('shopping_list').update({
          'name': updatedItem.name,
          'category': updatedItem.category,
        }).eq('id', updatedItem.id);
      } catch (e) {
        print("Failed to update item in shopping list: $e");
      }
    }
  }

  Future<void> toggleItemStatus(String itemId) async {
    final item = _groceryItems.firstWhere((item) => item.id == itemId);
    item.isPurchased = !item.isPurchased;
  }
}
