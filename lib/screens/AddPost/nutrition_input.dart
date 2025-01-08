import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NutritionInput extends StatefulWidget {
  final Function(Map<String, int>) onChanged;

  const NutritionInput({super.key, required this.onChanged});

  @override
  State<NutritionInput> createState() => _NutritionInputState();
}

class _NutritionInputState extends State<NutritionInput> {
  final Map<String, int> _nutritionData = {
    'Protein': 0,
    'Carbs': 0,
    'Fat': 0,
  };

  void _updateData(String type, int value) {
    setState(() {
      _nutritionData[type] = value;
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
                  initialValue: entry.value.toString(),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  cursorColor: Colors.black,
                  decoration: const InputDecoration(
                    labelText: 'Quantity (g)',
                    labelStyle: TextStyle(color: Colors.black),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1),
                    ),
                  ),
                  onChanged: (value) {
                    _updateData(type, int.tryParse(value) ?? 0);
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
