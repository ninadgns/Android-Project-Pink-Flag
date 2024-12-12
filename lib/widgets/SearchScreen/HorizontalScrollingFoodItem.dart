import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
      width: 250,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            right: _width / 25,
            child: Container(
              height: 190,
              width: 190,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.bookmark_border_rounded,
                      ),
                      color: Colors.white,
                      iconSize: 18.0,
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
            ),
          ),
          Positioned(
            top: 8,
            left: 0,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: _width / 4,
              child: CircleAvatar(
                child: Text('Ami khabarer chobi'),
                backgroundColor: color,
                radius: _width / 4.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
