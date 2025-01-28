Future<void> _addToAvailableList(BuildContext context, Function updateState) async {
  final user = FirebaseAuth.instance.currentUser;

  print("Firebase User: $user");

  if (user == null) {
    _showErrorDialog(context, "You must be logged in to add ingredients.");
    return;
  }

  final userId = user.uid;
  print("Firebase User ID: $userId");

  try {
    // Fetch elements table to match ingredient names
    final elementsResponse = await Supabase.instance.client
        .from('elements')
        .select('ingredient_id, name');

    List<Map<String, dynamic>> elements = List<Map<String, dynamic>>.from(elementsResponse);

    for (var ingredient in _ingredients) {
      final name = ingredient['name'].toString().toLowerCase();

      // Match with elements table (case insensitive)
      final matchedElement = elements.firstWhere(
            (element) => element['name'].toString().toLowerCase() == name,
        orElse: () => {},
      );

      final ingredientId = matchedElement.isNotEmpty ? matchedElement['ingredient_id'] : null;

      // Insert into available_ingredients with Firebase User ID
      await Supabase.instance.client.from('available_ingredients').insert({
        'user_id': userId,
        'ingredient_name': ingredient['name'],
        'ingredient_id': ingredientId,
        'created_at': DateTime.now().toIso8601String(),
      });
    }

    // Show success message and clear items
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ingredients added successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Clear all items using updateState
      updateState(() {
        _ingredients.clear();  // Clear ingredients list
        _imageBytes = null;    // Clear image
        _manualInputController.clear();  // Clear text input
      });
    }

  } catch (e) {
    _showErrorDialog(context, "Failed to add ingredients: $e");
  }
}