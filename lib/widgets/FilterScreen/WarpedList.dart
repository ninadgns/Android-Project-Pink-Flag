import 'package:flutter/material.dart';

import 'FlatButton.dart';

class WarpedList extends StatefulWidget {
  const WarpedList(
      {super.key,
      required this.items,
      required this.title,
      required this.onSelectionChanged});
  final List<String> items;
  final String title;
  final ValueChanged<List<String>> onSelectionChanged;

  @override
  State<WarpedList> createState() => _WarpedListState();
}

class _WarpedListState extends State<WarpedList> {
  final List<String> _selectedItems = [];

  void _toggleSelection(String item) {
  setState(() {
    if (_selectedItems.contains(item)) {
      _selectedItems.remove(item);
    } else {
      _selectedItems.add(item);
    }
    widget.onSelectionChanged(_selectedItems);
    });
}


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 5,
          runSpacing: -1,
          crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            ...widget.items.map((item) {
              return FlatButton(item: item, toggleSelection: _toggleSelection, isSelected: _selectedItems.contains(item));
            }),
            
          ],
        ),
      ],
    );
  }
}
