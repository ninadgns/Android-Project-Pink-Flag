import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AvailableIngredientService {
  final supabase = Supabase.instance.client;

  Future<void> addScannedIngredients(List<Map<String, dynamic>> ingredients) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception("User not logged in");
    }

    final userId = user.uid; // Firebase User ID
    print("Firebase User ID: $userId");

    try {
      // Fetch elements table to match ingredient names
      final elementsResponse = await supabase
          .from('elements')
          .select('ingredient_id, name');

      List<Map<String, dynamic>> elements = List<Map<String, dynamic>>.from(elementsResponse);

      for (var ingredient in ingredients) {
        final name = ingredient['name'].toString().toLowerCase();

        // Match with elements table (case insensitive)
        final matchedElement = elements.firstWhere(
              (element) => element['name'].toString().toLowerCase() == name,
          orElse: () => {},
        );

        final ingredientId = matchedElement.isNotEmpty ? matchedElement['ingredient_id'] : null;

        // Insert into available_ingredients
        await supabase.from('available_ingredients').insert({
          'user_id': userId, // Store Firebase User ID
          'ingredient_name': ingredient['name'],
          'ingredient_id': ingredientId, // Foreign key (null if not found)
          'created_at': DateTime.now().toIso8601String(),
        });
      }

      print("Ingredients added successfully!");
    } catch (e) {
      print("Failed to add ingredients: $e");
      throw Exception("Error adding ingredients: $e");
    }
  }
}
