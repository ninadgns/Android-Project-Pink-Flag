import 'package:flutter/material.dart';

class NutritionInput extends StatefulWidget {
  final Function(Map<String, dynamic>) onChanged;

  const NutritionInput({super.key, required this.onChanged});

  @override
  State<NutritionInput> createState() => _NutritionInputState();
}

class _NutritionInputState extends State<NutritionInput> {
  final Map<String, dynamic> _nutritionData = {
    'Protein': {'quantity': 0, 'unit': 'g'},
    'Carbs': {'quantity': 0, 'unit': 'g'},
    'Fat': {'quantity': 0, 'unit': 'g'},
  };

  final List<String> _units = ['g', 'cal'];

  void _updateData(String type, String key, dynamic value) {
    setState(() {
      _nutritionData[type]![key] = value;
    });
    widget.onChanged(_nutritionData);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Nutrition', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ..._nutritionData.entries.map((entry) {
          String type = entry.key;
          return Row(
            children: [
              Expanded(flex: 2, child: Text(type)),
              const SizedBox(width: 8),
              Expanded(
                flex: 3,
                child: TextFormField(
                  initialValue: entry.value['quantity'].toString(),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Quantity'),
                  onChanged: (value) {
                    _updateData(type, 'quantity', int.tryParse(value) ?? 0);
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: DropdownButtonFormField<String>(
                  value: entry.value['unit'],
                  items: _units
                      .map((unit) => DropdownMenuItem(
                    value: unit,
                    child: Text(unit),
                  ))
                      .toList(),
                  onChanged: (value) {
                    _updateData(type, 'unit', value!);
                  },
                ),
              ),
            ],
          );
        }).toList(),
      ],
    );
  }
}
