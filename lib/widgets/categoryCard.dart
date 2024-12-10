import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final IconData iconData;
  final String title;
  final bool selected;
  const CategoryCard({
    super.key,
    required this.iconData,
    required this.title,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;

    return Container(
      height: _height * 0.18,
      width: _width * 0.28,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween<double>(
              begin: _height * 0.05,
              end: selected ? _height * 0.06 : _height * 0.05,
            ),
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeInOut,
            builder: (context, size, child) {
              return Icon(
                iconData,
                color: selected ? Colors.black : Colors.grey,
                size: size,
              );
            },
          ),
          const SizedBox(height: 16),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeInOut,
            style: TextStyle(
              color: selected ? Colors.black : Colors.grey,
              fontSize: selected ? _height * 0.018 : _height * 0.016,
            ),
            child: Text(title),
          ),
        ],
      ),
    );
  }
}
