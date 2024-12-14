import 'package:flutter/material.dart';

import '../../data/constants.dart';
import 'CollectionItem.dart';

class LibraryCollections extends StatelessWidget {
  const LibraryCollections({super.key});

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Number of columns
        mainAxisSpacing: 8.0, // Spacing between rows
        crossAxisSpacing: 10.0, // Spacing between columns
        childAspectRatio: 1.0, // Aspe+ct ratio of each item
        mainAxisExtent: _height/4.2, // Height of each item
      ),
      itemBuilder: (context, index) {
        return CollectionItem(
          index: index,
        );
      },
      itemCount: 20,
    );
  }
}

