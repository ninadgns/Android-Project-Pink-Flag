import 'package:flutter/material.dart';

import '../../data/constants.dart';

class SavedItem extends StatelessWidget {
  SavedItem({super.key, required this.index});
  int index;
  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.all(3),
      child: Column(
        children: [
          Container(
            height: _height / 6.5,
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: colorShades[index % colorShades.length],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: _width / 8, // Adjust the radius to change the size
                child: const Text(
                  'Khabarer chobi',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Saved $index',
            style: Theme.of(context).textTheme.titleMedium,
            softWrap: false,
            overflow: TextOverflow.ellipsis,
          ),
          Text('${(index + 1) * 7} recipes'),
        ],
      ),
    );
  }
}
