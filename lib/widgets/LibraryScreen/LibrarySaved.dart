import 'package:flutter/material.dart';
import '/widgets/LibraryScreen/SavedItem.dart';

import '../../data/constants.dart';
import '../../screens/RecipeIntroScreen.dart';
import 'CollectionItem.dart';

class LibrarySaved extends StatelessWidget {
  const LibrarySaved({super.key});

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Number of columns
        mainAxisSpacing: 8.0, // Spacing between rows
        crossAxisSpacing: 10.0, // Spacing between columns
        childAspectRatio: 1.0, // Aspe+ct ratio of each item
        mainAxisExtent: _height / 4.2, // Height of each item
      ),
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (ctx) => RecipeIntro()));
          },
          child: SavedItem(
            index: index,
          ),
        );
      },
      itemCount: 10,
    );
  }
}
