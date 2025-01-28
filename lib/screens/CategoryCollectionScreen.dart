import 'package:dim/models/CollectionModel.dart';
import 'package:flutter/material.dart';

import '../widgets/Recipe/MealItem.dart';
import '../widgets/SearchScreen/ReicipeListView.dart';

class Categorycollectionscreen extends StatelessWidget {
  Categorycollectionscreen({super.key, required this.item});
  CollectionModelItem item;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black,
                    ),
                  ),
                  // SizedBox(width: 10),
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              collectionsList.value.isNotEmpty
                  ? Column(
                      children: item.collectionRecipes.map((recipe) {
                        return MealItem(
                          recipe: recipe,
                          collections: collectionsList.value,
                        );
                      }).toList(),
                    )
                  : const Center(
                      child: Text('No collections found'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
