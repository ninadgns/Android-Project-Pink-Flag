import 'package:flutter/material.dart';

import 'FlatButton.dart';

class WarpedList extends StatefulWidget {
  const WarpedList({super.key, required this.items, required this.title});
  final List<String> items;
  final String title;
  @override
  State<WarpedList> createState() => _WarpedListState();
}

class _WarpedListState extends State<WarpedList> {
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
              return FlatButton(item: item);
            }).toList(),
          ],
        ),
      ],
    );
  }
}
