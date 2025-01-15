// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

import '../../models/RecipeModel.dart';
import '../../screens/RecipeIntroScreen.dart';

class HorizontalScrollingFood extends StatelessWidget {
  final Recipe recipe;
  final Color boxColor;

  HorizontalScrollingFood({
    super.key,
    required this.recipe,
    required this.boxColor,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    recipe.calculateTotalDuration();
    return SizedBox(
      width: width / 1.3,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            right: width / 25,
            child: InkWell(
              borderRadius: BorderRadius.circular(40),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipeIntro(
                      recipe: recipe,
                    ),
                  ),
                );
              },
              child: Container(
                height: width / 2,
                width: width / 2,
                decoration: BoxDecoration(
                  color: boxColor, // Custom color for the container
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Stack(children: [
                  Positioned(
                    top: width / 30,
                    right: width / 30,
                    child: IconButton(
                      onPressed: () {
                        print('Bookmark pressed');
                      },
                      icon: const Icon(
                        Icons.bookmark_border_rounded,
                      ),
                      color: Colors.white,
                      iconSize: 18.0,
                      highlightColor: Colors.black12,
                      padding: const EdgeInsets.all(0),
                      splashRadius: 14.0,
                      constraints: const BoxConstraints(
                        minHeight: 36,
                        minWidth: 36,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: width / 15,
                    left: width / 20,
                    right: width / 20, // Allow Row to expand to full width
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recipe.name,
                          style:
                              Theme.of(context).textTheme.labelLarge!.copyWith(
                                    color: Colors.black,
                                  ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.star_border_rounded,
                                  color: Colors.black,
                                  size: 20,
                                ),
                                Text(
                                  '4.5',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  '${recipe.totalDuration} min ',
                                  style: const TextStyle(
                                    color: Colors.black26,
                                    fontSize: 14,
                                  ),
                                ),
                                const Icon(
                                  Icons.watch_later_outlined,
                                  size: 16,
                                  color: Colors.black38,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: InkWell(
              borderRadius: BorderRadius.circular(100),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipeIntro(
                      recipe: recipe,
                    ),
                  ),
                );
              },
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: width / 4,
                child: CircleAvatar(
                  backgroundColor: Colors.grey.shade200,
                  radius: width / 4.5,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.network(
                      recipe.titlePhoto,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                        size: width / 8,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
