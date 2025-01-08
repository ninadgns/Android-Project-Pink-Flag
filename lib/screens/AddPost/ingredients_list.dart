import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  String _selectedUnit = 'g';

  final List<String> _units = ['g', 'kg', 'pcs', 'cup', 'ml', 'tbsp'];

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
        'quantity': double.tryParse(_ingredientQuantityController.text) ?? 0.0,
        'unit': _selectedUnit,
      });
      _ingredientNameController.clear();
      _ingredientQuantityController.clear();
      _selectedUnit = 'g';
    });
    widget.onChanged(_ingredients);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Ingredients*',
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: TextFormField(
                controller: _ingredientNameController,
                cursorColor: Colors.black,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(color: Colors.black),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 2,
              child: TextFormField(
                controller: _ingredientQuantityController,
                cursorColor: Colors.black,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  hintText: 'e.g., 1, 2, 0.5',
                  labelStyle: TextStyle(color: Colors.black),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 2,
              child: DropdownButtonFormField<String>(
                dropdownColor: const Color(0xFFD0DFF0),
                value: _selectedUnit,
                items: _units.map((unit) {
                  return DropdownMenuItem(
                    value: unit,
                    child: Text(unit),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedUnit = value!;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Unit',
                  labelStyle: TextStyle(color: Colors.black),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1),
                  ),
                ),
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
                subtitle: Text(
                    'Quantity: ${ingredient['quantity']} ${ingredient['unit']}'),
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
