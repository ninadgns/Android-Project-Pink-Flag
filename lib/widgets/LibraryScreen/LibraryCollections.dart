import 'package:dim/screens/CollectionsScreen.dart';
import 'package:dim/widgets/SearchScreen/ReicipeListView.dart';
import 'package:flutter/material.dart';

import '../../data/constants.dart';
import '../../screens/RecipeIntroScreen.dart';
import 'CollectionItem.dart';

class LibraryCollections extends StatefulWidget {
   LibraryCollections({super.key, required this.flag});
  bool flag ;
  @override
  State<LibraryCollections> createState() => _LibraryCollectionsState();
}

class _LibraryCollectionsState extends State<LibraryCollections> {
  // late List<CollectionItem> _collectionList = [];
  bool _isLoading = false;
  // List<Map<String, dynamic>> collections=[];
  @override
  void initState() {
    super.initState();
    // _fetchAndSetRecipes();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    if (collectionsList.value.isEmpty) {
      return Center(
          child: Column(
        children: [
          SizedBox(height: height * 0.3),
          const Text('No collections found'),
        ],
      ));
    }
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Number of columns
        mainAxisSpacing: 8.0, // Spacing between rows
        crossAxisSpacing: 10.0, // Spacing between columns
        childAspectRatio: 1.0, // Aspe+ct ratio of each item
        mainAxisExtent: height / 4.2, // Height of each item
      ),
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (ctx) => CollectionsScreen(
                          item: collectionsList.value[index],
                        )));
          },
          child: CollectionItem(
            index: index,
            item: collectionsList.value[index],
          ),
        );
      },
      itemCount: collectionsList.value.length,
    );
  }
}
