import 'package:flutter/material.dart';

import 'FoodValBox.dart';

class DetailsInfo extends StatelessWidget {
  const DetailsInfo({
    super.key,
    required this.energy,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.description,
  });
  final int energy;
  final int protein;
  final int carbs;
  final int fat;
  final String description;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FoodValBox(
              width: width,
              foodVal: '$energy k',
              valType: 'Energy',
            ),
            FoodValBox(
              width: width,
              foodVal: '$protein g',
              valType: 'Protein',
            ),
            FoodValBox(
              width: width,
              foodVal: '$carbs g',
              valType: 'Carbs',
            ),
            FoodValBox(
              width: width,
              foodVal: '$fat g',
              valType: 'Fat',
            )
          ],
        ),
        const SizedBox(height: 20),
        Text(description),
        const SizedBox(height: 100),
      ],
    );
  }
}
