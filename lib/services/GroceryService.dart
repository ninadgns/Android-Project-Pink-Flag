import '../models/GroceryModel.dart';

class GroceryService {
  // this would be a database or API call
  static final List<GroceryItem> _groceryItems = [];

  Future<List<GroceryItem>> getGroceryListByCategory(String category) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _groceryItems.where((item) =>
    item.category.toLowerCase() == category.toLowerCase()).toList();
  }

  Future<void> addGroceryItem(GroceryItem item) async {
    _groceryItems.add(item);
  }

  Future<void> removeItem(String itemId) async {
    _groceryItems.removeWhere((item) => item.id == itemId);
  }

  Future<void> updateItem(GroceryItem updatedItem) async {
    final index = _groceryItems.indexWhere((item) => item.id == updatedItem.id);
    if (index != -1) {
      _groceryItems[index] = updatedItem;
    }
  }

  Future<void> toggleItemStatus(String itemId) async {
    final item = _groceryItems.firstWhere((item) => item.id == itemId);
    item.isPurchased = !item.isPurchased;
  }

}