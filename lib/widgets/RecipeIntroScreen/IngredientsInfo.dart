
import 'package:flutter/material.dart';

class IngredientsInfo extends StatelessWidget {
  const IngredientsInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'How many servings?',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[500]),
            ),
            Row(
              crossAxisAlignment:
              CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.remove_circle_rounded,
                    color: Colors.black,
                    size: 40,
                  ),
                ),
                Text(
                  '4',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.add_circle_rounded,
                    color: Colors.black,
                    size: 40,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 16),
        // Ingredient List Header
        Text(
          '10 Items',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
