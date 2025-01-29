import 'package:flutter/material.dart';

class DateSelector extends StatelessWidget {
  final String label;
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const DateSelector({
    required this.label,
    required this.selectedDate,
    required this.onDateSelected,
    super.key,
  });

  String _formatDate(DateTime date) {
    return '${date.day} ${_getMonthName(date.month)}';
  }

  String _getMonthName(int month) {
    const List<String> months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textScale = MediaQuery.of(context).textScaleFactor;
    final padding = size.width * 0.03;
    final iconSize = size.width * 0.045;

    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 30)),
        );
        if (date != null) onDateSelected(date);
      },
      child: Container(
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today,
              size: iconSize,
              color: Colors.grey[600],
            ),
            SizedBox(width: size.width * 0.02),
            Text(
              _formatDate(selectedDate),
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: textScale * 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}