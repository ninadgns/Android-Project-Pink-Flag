import 'package:dim/data/constants.dart';
import 'package:flutter/material.dart';

import '../../screens/RecipeIntroScreen.dart';

class HorizontalScrollingFood extends StatelessWidget {
  HorizontalScrollingFood({
    super.key,
    required this.color,
  });
  Color color;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

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
                    builder: (context) => RecipeIntro(recipe: dummyRecipe,),
                  ),
                );
              },
              child: Container(
                height: width / 2,
                width: width / 2,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Stack(children: [
                  Positioned(
                    top: width / 30,
                    right: width / 30,
                    child: IconButton(
                      onPressed: () {
                        print(33333);
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
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          Colors.black.withOpacity(0.15),
                        ),
                        shape: WidgetStateProperty.all(const CircleBorder()),
                      ),
                    ),
                  ),
                  Stack(
                    children: [
                      Positioned(
                        bottom: width / 15,
                        left: width / 20,
                        right: width / 20, // Allow Row to expand to full width
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pumpkin Soup',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(
                                    color: Colors.black,
                                  ),
                            ),
                            const Row(
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
                                      ' 4.8',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '56 min ',
                                      style: TextStyle(
                                        color: Colors.black26,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Icon(
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
                    ],
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
                    builder: (context) => RecipeIntro(recipe: dummyRecipe,),
                  ),
                );
              },
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: width / 4,
                child: CircleAvatar(
                  backgroundColor: color,
                  radius: width / 4.5,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.asset(
                      'assets/pumpkin_soup.jpg',
                      fit: BoxFit.cover,
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
