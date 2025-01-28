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
    final screenSize = MediaQuery.of(context).size;
    final scale = screenSize.width / 375.0; // Base scale on iPhone SE width

    // Calculate dynamic sizes
    final fontSize = (14 * scale).clamp(12.0, 16.0);
    final horizontalPadding = (8.0 * scale).clamp(6.0, 12.0);
    final verticalPadding = (4.0 * scale).clamp(3.0, 8.0);

    return Padding(
      padding: EdgeInsets.only(
        right: horizontalPadding,
        bottom: verticalPadding,
      ),
      child: FilterChip(
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF004D40),
            fontSize: fontSize,
          ),
        ),
        selected: isSelected,
        onSelected: onSelected,
        showCheckmark: false,
        backgroundColor: const Color(0xFFE0F2F1),
        selectedColor: const Color(0xFF26A69A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20 * scale),
          side: BorderSide(
            color: Colors.grey.shade300,
            width: 0.5,
          ),
        ),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        labelPadding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding / 2,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}