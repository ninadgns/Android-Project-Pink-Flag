import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../screens/RecipeIntroScreen.dart';

class HorizontalScrollingFood extends StatelessWidget {
  HorizontalScrollingFood({
    super.key,
    required this.color,
  });
  Color color;

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    return Container(
      width: _width / 1.3,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            right: _width / 25,
            child: InkWell(
              borderRadius: BorderRadius.circular(40),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipeIntro(),
                  ),
                );
              },
              child: Container(
                height: _width / 2,
                width: _width / 2,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Stack(children: [
                  Positioned(
                    top: _width / 30,
                    right: _width / 30,
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
                        bottom: _width / 15,
                        left: _width / 20,
                        right: _width / 20, // Allow Row to expand to full width
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Khabar er naam',
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
                                      ' 4.5',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '20 min ',
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
                    builder: (context) => RecipeIntro(),
                  ),
                );
              },
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: _width / 4,
                child: CircleAvatar(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.asset(
                      'assets/pumpkin_soup.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  backgroundColor: color,
                  radius: _width / 4.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
