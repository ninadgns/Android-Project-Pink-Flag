import 'package:dim/models/CollectionModel.dart';
import 'package:flutter/material.dart';

import '../../data/constants.dart';

class CollectionItem extends StatefulWidget {
  CollectionItem({
    super.key,
    required this.index,
    required this.item,
  });

  int index;
  CollectionModelItem item;

  @override
  State<CollectionItem> createState() => _CollectionItemState();
}

class _CollectionItemState extends State<CollectionItem> {
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    func();
  }

  void func() async {
    await widget.item.findCollectionItems();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    if(isLoading){
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Container(
      margin: const EdgeInsets.all(3),
      child: Column(
        children: [
          Icon(
            Icons.collections_bookmark_sharp,
            size: height / 10,
            color: colorShades[widget.index % 5],
          ), // Icon

          SizedBox(height: height * 0.01),
          Text(
            widget.item.name,
            style: Theme.of(context).textTheme.titleMedium,
            softWrap: false,
            overflow: TextOverflow.ellipsis,
          ),
          Text("${widget.item.collectionRecipes.length} recipes"),
        ],
      ),
    );
  }
}
