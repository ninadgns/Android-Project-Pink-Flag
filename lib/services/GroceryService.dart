import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/GroceryModel.dart';

class GroceryService {
  // this would be a database or API call
  static final List<GroceryItem> _groceryItems = [];

  Future<List<GroceryItem>> getGroceryListByCategory(String category) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    try {
      final response = await Supabase.instance.client
          .from('shopping_list')
          .select('*')
          .eq('category', category)
          .eq('user_id', user.uid);

      var a = response
          .map<GroceryItem>((item) => GroceryItem(
                id: item['id'],
                name: item['name'],
                quantity: (item['quantity'] as num?)?.toDouble() ??
                    0.0, // Default: 0.0
                unit: item['unit'] ?? '', // Default: Empty String
                description: item['description'] ?? '', // Default: Empty String
                category: item['category'],
                icon: item['icon'],
                isPurchased: item['is_purchased'] ?? false, // Default: false
                addedDate: DateTime.parse(item['created_at']),
                userId: item['user_id'],
              ))
          .toList();
      print("Grocery items: $a");
      return a;
    } catch (e) {
      print("Failed to fetch grocery items: $e");
      return [];
    }
  }

  Future<void> addGroceryItem(GroceryItem item) async {
    _groceryItems.add(item);
    try {
      await Supabase.instance.client.from('shopping_list').insert({
        'id': item.id,
        'name': item.name,
        'category': item.category,
        'user_id': FirebaseAuth.instance.currentUser!.uid,
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
