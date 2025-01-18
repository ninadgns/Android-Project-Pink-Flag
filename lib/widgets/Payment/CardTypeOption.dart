import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CardTypeOption extends StatelessWidget {
  final IconData icon;
  final String type;
  final Color color;
  final String? selectedType;
  final Function(String?) onChanged;

  const CardTypeOption({
    Key? key,
    required this.icon,
    required this.type,
    required this.color,
    required this.selectedType,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio<String>(
          value: type,
          groupValue: selectedType,
          onChanged: onChanged,
          activeColor: Colors.blue,
        ),
        Icon(icon, color: color),
      ],
    );
  }
}