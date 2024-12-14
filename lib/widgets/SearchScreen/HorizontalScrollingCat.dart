import 'package:flutter/material.dart';

import '../../data/constants.dart';
import 'categoryCard.dart';

class HorizontalScrollingCat extends StatefulWidget {
  const HorizontalScrollingCat({
    super.key,
    required double width,
    required this.onCategorySelected,
  }) : _width = width;

  final double _width;
  final Function(String) onCategorySelected;

  @override
  State<HorizontalScrollingCat> createState() => _HorizontalScrollingCatState();
}

int _selectedCategory = 0;

class _HorizontalScrollingCatState extends State<HorizontalScrollingCat> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget._width ,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            categories.length,
            (index) => InkWell(
              onTap: () {
                setState(() {
                  _selectedCategory = index;
                });
                widget.onCategorySelected(categories[index]);
              },
              borderRadius: BorderRadius.circular(20),
              child: CategoryCard(
                title: categories[index],
                iconData: categoryIcons[index],
                selected: index == _selectedCategory,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
