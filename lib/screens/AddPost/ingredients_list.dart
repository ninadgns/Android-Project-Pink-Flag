import 'package:flutter/material.dart';

class IngredientsList extends StatefulWidget {
  final Function(List<Map<String, dynamic>>) onChanged;

  const IngredientsList({super.key, required this.onChanged});

  @override
  State<IngredientsList> createState() => _IngredientsListState();
}

class _IngredientsListState extends State<IngredientsList> {
  final TextEditingController _ingredientNameController =
  TextEditingController();
  final TextEditingController _ingredientQuantityController =
  TextEditingController();
  final List<Map<String, dynamic>> _ingredients = [];

  void _addIngredient() {
    if (_ingredientNameController.text.isEmpty ||
        _ingredientQuantityController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter ingredient details')),
      );
      return;
    }

    setState(() {
      _ingredients.add({
        'name': _ingredientNameController.text,
        'quantity': _ingredientQuantityController.text,
      });
      _ingredientNameController.clear();
      _ingredientQuantityController.clear();
    });
    widget.onChanged(_ingredients);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Ingredients*', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _ingredientNameController,
                decoration: const InputDecoration(labelText: 'Ingredient'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                controller: _ingredientQuantityController,
                decoration: const InputDecoration(labelText: 'Quantity'),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _addIngredient,
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (_ingredients.isNotEmpty)
          ..._ingredients.map((ingredient) => ListTile(
            leading: const Icon(Icons.kitchen),
            title: Text(ingredient['name']),
            subtitle: Text('Quantity: ${ingredient['quantity']}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                setState(() {
                  _ingredients.remove(ingredient);
                });
                widget.onChanged(_ingredients);
              },
            ),
          )),
      ],
    );
  }
}
