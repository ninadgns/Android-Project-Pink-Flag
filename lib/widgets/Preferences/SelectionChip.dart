import 'package:flutter/material.dart';

class SelectionChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Function(bool) onSelected;
  final bool isCustom;

  const SelectionChip({
    required this.label,
    required this.isSelected,
    required this.onSelected,
    this.isCustom = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
      child: FilterChip(
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF004D40),
          ),
        ),
        selected: isSelected,
        onSelected: onSelected,
        showCheckmark: false,
        backgroundColor: const Color(0xFFE0F2F1),
        selectedColor: const Color(0xFF26A69A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
        labelPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      ),
    );
  }
}
